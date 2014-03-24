class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :voter_id
      t.string :voted_type
      t.integer :voted_id
      t.integer :category_id
      t.integer :rank
      
      t.timestamps
    end
  end
end
