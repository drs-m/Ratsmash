class AddActiveToStudents < ActiveRecord::Migration
  def change
    add_column :students, :active, :boolean
    remove_column :students, :password_resetkey, :string
  end
end
