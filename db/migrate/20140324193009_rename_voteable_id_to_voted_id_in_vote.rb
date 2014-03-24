class RenameVoteableIdToVotedIdInVote < ActiveRecord::Migration
  def change
  	change_table :votes do |t|
  		t.rename :voteable_id, :voted_id
  	end
  end
end
