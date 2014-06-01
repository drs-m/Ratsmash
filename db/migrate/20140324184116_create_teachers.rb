class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :name
      t.boolean :gender
      t.boolean :closed

      t.timestamps
    end
  end
end
