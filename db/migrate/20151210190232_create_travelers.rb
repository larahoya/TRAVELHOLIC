class CreateTravelers < ActiveRecord::Migration
  def change
    create_table :travelers do |t|
      t.references :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :country
      t.datetime :date_of_birth
      t.string :gender

      t.timestamps null: false
    end
  end
end
