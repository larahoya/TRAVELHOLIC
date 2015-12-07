class CreateTravels < ActiveRecord::Migration
  def change
    create_table :travels do |t|
      t.string :title
      t.text :description
      t.datetime :initial_date
      t.datetime :final_date
      t.string :countries
      t.string :places
      t.string :budget
      t.string :requirements
      t.integer :maximum_people
      t.integer :people

      t.timestamps null: false
    end
  end
end
