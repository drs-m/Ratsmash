# encoding: utf-8
class Vote < ActiveRecord::Base

	belongs_to :voter, class_name: "Student"
	belongs_to :voted, polymorphic: true
	belongs_to :category

	def to_s
		"#{self.category.name} (#{self.rating.to_s}): #{self.voter.name} -> #{self.voted.name}"
	end

	def self.top_points(calc_points = false)
		counts = {}

		Vote.where(category_id: Category.where(group_id: Group.where(student: true, teacher: false).ids).ids).each do |v|
			identifier = v.voter.name + " => " + v.voted.name
			counts[identifier] ||= 0
			counts[identifier] += calc_points ? v.rating : 1
		end

		counts.sort_by { |k,v| v }.reverse
	end

	def self.by_voter_in_category(options = {})
		if options[:voter] && options[:category]
			voted = []
			3.times { |i| voted[i] = options[:voter].given_votes.where(category_id: options[:category].id, rating: 3-i).first }
			return voted
		end
	end

end
