class AddGenderAndAvatarToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :avatar, :string
  end
end
