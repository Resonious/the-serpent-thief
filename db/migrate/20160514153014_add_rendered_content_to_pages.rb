class AddRenderedContentToPages < ActiveRecord::Migration
  def change
    add_column :pages, :rendered_content, :text
    add_column :blog_posts, :rendered_content, :text
  end
end
