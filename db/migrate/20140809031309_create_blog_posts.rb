class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.text :content
      t.references :page

      t.timestamps
    end

    add_index :blog_posts, :page_id
  end
end
