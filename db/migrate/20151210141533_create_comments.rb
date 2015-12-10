class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :travel, index: true
      t.string :description
      t.boolean :type

      t.timestamps null: false
    end
  end
end
