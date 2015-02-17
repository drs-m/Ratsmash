class RemovePollIdFromPollVotes < ActiveRecord::Migration
  def change
    remove_column :poll_votes, :poll_id, :integer
  end
end
