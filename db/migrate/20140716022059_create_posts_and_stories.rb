class CreatePostsAndStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :name
      t.string :link

      t.boolean :active

      t.timestamps
    end

    create_table :pages do |t|
      t.integer :number

      t.text :content
      t.references :story
      t.boolean :published

      t.timestamps
    end

    add_index :pages, :story_id
    add_index :stories, :link
  end
end
