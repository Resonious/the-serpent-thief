xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title @story.name
    if @story.description.blank?
      xml.description 'no description'
    else
      xml.description @story.description
    end
    xml.link clean_contents_path(@story)
    xml.language 'en-us'
    xml.image do
      xml.url image_path('the-serpent-thief.png')
      xml.title ENV['SITE_NAME'] || 'PLZ SET SITE_NAME'
      xml.link root_path
    end

    @story.pages.find_each do |page|
      xml.item do
        xml.title "#{page.number}) #{page.first_5_words}"
        xml.description page.content
        xml.pubDate page.created_at.to_s(:rfc822)
        xml.link clean_page_path(@story, page.number)
        xml.guid clean_page_path(@story, page.number)
      end
    end
  end
end
