class RemoveColumnFromTravels < ActiveRecord::Migration
  def change
    remove_column :travels, :countries
    remove_column :travels, :places
    remove_column :travels, :requirements
  end
end
