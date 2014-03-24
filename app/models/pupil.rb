class Pupil < ActiveRecord::Base

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote"
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	def name
		first_name + " " + last_name
	end

end
