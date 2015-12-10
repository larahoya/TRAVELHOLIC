class RemoveTypeColumnFromComments < ActiveRecord::Migration
  def change
    remove_column :comments, :type
    add_column :comments, :category, :boolean, default: false
  end
end
