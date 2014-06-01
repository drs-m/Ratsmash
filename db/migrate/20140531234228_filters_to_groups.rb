class FiltersToGroups < ActiveRecord::Migration
  def change
  	remove_column :categories, :female, :boolean
  	remove_column :categories, :male, :boolean
  	remove_column :categories, :student, :boolean
  	remove_column :categories, :teacher, :boolean
  	add_column :categories, :group, :string
  end
end
