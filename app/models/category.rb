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

        sum_points = self.votes.sum :rating
		data = Category.connection.select_all("select name, sum(rating) as points from votes inner join #{table} on votes.voted_id = #{table}.id where votes.category_id = #{self.id} group by name order by points desc limit 3").to_a
		data.map { |hash| OpenStruct.new hash.merge("percentage" => (hash["points"]/sum_points.to_f).round(2)) }
	end

	def vote_count(user)
		user.given_votes.where(category_id: self.id).count
	end

	def voting_done(user)
		vote_count(user) >= 3
	end

	def self.results_to_s
		results = Category.order(:group_id, :name).map { |c1| OpenStruct.new({ category: c1, ranking: c1.top_3 }) }
		results.map do |result|
			out = ""
			out += "(#{result.category.group.name}) #{result.category.name}:\n"
			result.ranking.each_with_index do |rank, i|
				out += "#{i+1}. #{rank.name} (#{rank.points})\n"
			end
			out + "\n"
		end
	end

	private
		def set_defaults
			self.closed ||= false
		end

end
