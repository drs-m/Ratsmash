class AddClosedToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :closed, :boolean
  end
end
