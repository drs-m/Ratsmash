class CreatePollVotes < ActiveRecord::Migration
  def change
    create_table :poll_votes do |t|
      t.integer :poll_id
      t.integer :poll_option_id
      t.integer :student_id	
      t.timestamps
    end
  end
end
