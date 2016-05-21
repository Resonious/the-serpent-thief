class CreateWebpages < ActiveRecord::Migration
  def change
    create_table :webpages do |t|
      t.text :content
      t.text :rendered_content
      t.string :path, index: true
      t.string :name
      t.boolean :show_link, index: true
    end
  end
end
