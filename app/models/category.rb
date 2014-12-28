# encoding: utf-8
class Category < ActiveRecord::Base

	after_validation :set_defaults

	has_many :votes
	belongs_to :group

	validates :name, :group_id, presence: true

	def top_3
		if self.group.student && !self.group.teacher
			table = "students"
		elsif self.group.teacher && !self.group.student
			table = "teachers"
		else
			return nil
		end

		data = Category.connection.select_all("select name, sum(rating) as points from votes inner join #{table} on votes.voted_id = #{table}.id where votes.category_id = #{self.id} group by name order by points desc limit 3").to_a
		data.map { |hash| OpenStruct.new hash }
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
