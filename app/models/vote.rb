class Vote < ActiveRecord::Base

	belongs_to :voter, class_name: "Student"
	belongs_to :voted, polymorphic: true
	belongs_to :category

end
