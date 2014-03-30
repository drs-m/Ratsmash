# encoding: utf-8
class Vote < ActiveRecord::Base

	belongs_to :voter, class_name: "Student"
	belongs_to :voted, polymorphic: true
	belongs_to :category

	def self.by_voter_in_category(options = {})
		if options[:voter] && options[:category]
			voted = []
			3.times { |i| voted[i] = options[:voter].given_votes.where(category_id: options[:category].id, rating: 3-i).first }
			return voted
		end
	end

end
