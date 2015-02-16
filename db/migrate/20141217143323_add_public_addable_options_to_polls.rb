class AddPublicAddableOptionsToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :dynamic_options, :boolean
  end
end
