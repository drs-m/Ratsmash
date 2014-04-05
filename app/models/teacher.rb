class Teacher < ActiveRecord::Base

	has_many :achieved_votes, class_name: "Vote", :as => :voted

	scope :name_search, ->(name = "") { where("name LIKE ?", "%#{name}%") }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }
	
end
