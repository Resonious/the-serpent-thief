class RenderOldContent < ActiveRecord::Migration
  def up
    Page.find_each do |page|
      md_content = page.content
        .gsub('/<\/?em>/', "_")
        .gsub('/<\/?i>/', "_")
        .gsub('/<\/?strong>/', "**")
        .gsub('/<\/?b>/', "**")

      clean_content = HTML::FullSanitizer.new
        .sanitize(
          CGI.unescapeHTML(md_content)
             .gsub(/(\&nbsp;)|(<\/p>)/, ' ')
        )

      page.content = clean_content
      page.save!

      puts "-- Converted page ##{page.id} to markdown"
    end
  end

  def down
    Page.find_each do |page|
      page.update_column :content, page.rendered_content
      puts "-- Converted page ##{page.id} to HTML"
    end
  end
end
