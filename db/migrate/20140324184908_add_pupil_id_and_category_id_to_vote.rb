class AddPupilIdAndVoteableIdAndCategoryIdToVote < ActiveRecord::Migration
  def change
    add_column :votes, :pupil_id, :integer
    add_column :votes, :category_id, :integer
  end
end
