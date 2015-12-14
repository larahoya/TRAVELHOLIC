class AddAvatarToTravel < ActiveRecord::Migration
  def change
    add_column :travels, :avatar, :string
  end
end
