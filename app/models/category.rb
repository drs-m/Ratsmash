# encoding: utf-8
class Category < ActiveRecord::Base

	attr_accessor :category_result

	after_validation :set_defaults

	has_many :votes
	belongs_to :group

	validates :name, :group_id, presence: true

	def result
		@category_result ||= CategoryResult.new(self)
	end

	def self.all_results
		puts Category.where(id: Vote.all.map(&:category_id).uniq).order(:group_id => :asc, :name => :asc).map &:result
	end

	def to_s
		"(#{self.group.name}) #{self.name}"
	end

	def vote_count(user)
		user.given_votes.where(category_id: self.id).count
	end

	def voting_done(user)
		vote_count(user) >= 3
	end

	private
		def set_defaults
			self.closed ||= false
		end

end
