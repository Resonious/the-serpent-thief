class AddTagToPages < ActiveRecord::Migration
  def change
    add_column :pages, :tag, :string
  end
end
