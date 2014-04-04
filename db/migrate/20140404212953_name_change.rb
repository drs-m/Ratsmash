class NameChange < ActiveRecord::Migration
  def change
  	change_table :students do |t|
  		t.remove :last_name
  		t.rename :first_name, :name
  	end

  	change_table :teachers do |t|
  		t.remove :last_name
  		t.rename :first_name, :name
  	end
  end
end
