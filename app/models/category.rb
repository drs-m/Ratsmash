# encoding: utf-8
class Category < ActiveRecord::Base

	after_validation :set_defaults

	has_many :votes
	belongs_to :group

	validates :name, :group_id, presence: true

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
