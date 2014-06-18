class AddColumnToDescription < ActiveRecord::Migration
  def change
  	add_column :descriptions, :interests, :string
  	add_column :descriptions, :hobbies, :string
  end
end
