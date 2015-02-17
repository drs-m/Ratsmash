class ChangeMultipleToNumber < ActiveRecord::Migration
  def change
      remove_column :polls, :multiple, :boolean
      add_column :polls, :possible_votes, :integer
      change_table :polls do |t|
          t.rename :public_addable_options, :dynamic_options
      end
  end
end
