class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name, null: false
      t.references :user, index: true, null: false
      t.boolean :private, null: false
      t.boolean :completed, null: false

      t.timestamps
    end
  end
end
