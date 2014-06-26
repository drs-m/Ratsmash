class AddLockedToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :locked, :boolean
  end
end
