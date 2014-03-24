class Teacher < ActiveRecord::Base

	has_many :achieved_votes, class_name: "Vote", :as => :voted

	def name
		first_name + " " + last_name
	end

end
