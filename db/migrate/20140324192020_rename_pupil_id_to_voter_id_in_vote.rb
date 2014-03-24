class RenamePupilIdToVoterIdInVote < ActiveRecord::Migration
  def change
  	change_table :votes do |t|
  		t.rename :pupil_id, :voter_id
  	end
  end
end
