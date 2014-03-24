class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.boolean :applies_to_teacher

      t.timestamps
    end
  end
end
