class CreateClassTrips < ActiveRecord::Migration
  def change
    create_table :class_trips do |t|
      t.integer :sender_id
      t.string :course
      t.text :text

      t.timestamps
    end
  end
end
