class AddMultipleToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :multiple, :boolean, default: false
  end
end
