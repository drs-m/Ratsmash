class Pupil < ActiveRecord::Base

	has_secure_password

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote"
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	def self.search(params)
		if (params)
			querystring = params.keys[0].to_s + " LIKE :" + params.keys[0].to_s
			i = 1
			while i < params.length
				querystring += " AND " + params.keys[i].to_s + " LIKE :" + params.keys[i].to_s
				i += 1
			end
			params.each { |key, value| params[key] = "%" + value + "%" }
			where(querystring, params) # return results
		end
	end

	def name
		first_name + " " + last_name
	end

end
