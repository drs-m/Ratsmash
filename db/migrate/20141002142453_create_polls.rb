class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :name
      t.text :content
      t.integer :student_id

      t.timestamps
    end
  end
end
