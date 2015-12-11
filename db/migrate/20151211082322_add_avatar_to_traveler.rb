class AddAvatarToTraveler < ActiveRecord::Migration
  def change
    add_column :travelers, :avatar, :string
  end
end
