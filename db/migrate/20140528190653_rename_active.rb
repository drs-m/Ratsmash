class RenameActive < ActiveRecord::Migration
  def change
  	change_table :students do |t|
  		t.rename :active, :closed
  	end
  end
end
