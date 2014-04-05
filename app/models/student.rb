class Student < ActiveRecord::Base

	has_secure_password

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote"
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	scope :name_search, ->(name = "") { where("name LIKE ?", "%#{name}%") }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }

end
