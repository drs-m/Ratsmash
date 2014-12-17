class AddPublicAddableOptionsToPolls < ActiveRecord::Migration
  def change
    add_column :polls, :public_addable_options, :boolean
  end
end
