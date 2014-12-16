class CreateTags < ActiveRecord::Migration
  def change
    remove_column :pages, :tag
    add_index :pages, :number

    create_table :tags do |t|
      t.string :value
    end
    add_index :tags, :value, unique: true

    create_table :pages_tags do |t|
      t.integer :page_id
      t.integer :tag_id
    end
    add_index :pages_tags, [:page_id, :tag_id]
  end
end
