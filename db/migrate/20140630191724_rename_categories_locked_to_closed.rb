class RenameCategoriesLockedToClosed < ActiveRecord::Migration
  def change
    change_table :categories do |t|
        t.rename :locked, :closed
    end
  end
end
