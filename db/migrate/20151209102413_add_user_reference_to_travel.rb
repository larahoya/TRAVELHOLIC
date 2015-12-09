class AddUserReferenceToTravel < ActiveRecord::Migration
  def change
    add_reference :travels, :user, index: true
  end
end
