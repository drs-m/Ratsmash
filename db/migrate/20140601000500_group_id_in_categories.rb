class GroupIdInCategories < ActiveRecord::Migration
  def change
  	remove_column :categories, :group, :string
  	add_column :categories, :group_id, :integer
  end
end
