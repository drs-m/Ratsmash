class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :female
      t.boolean :male
      t.boolean :student
      t.boolean :teacher

      t.timestamps
    end
  end
end
