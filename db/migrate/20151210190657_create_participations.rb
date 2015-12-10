class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :travel, index: true
      t.references :traveler, index: true

      t.timestamps null: false
    end
  end
end
