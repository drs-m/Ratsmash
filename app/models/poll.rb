class Poll < ActiveRecord::Base
	has_many :poll_options, :dependent => :destroy
	has_many :poll_votes, :dependent => :destroy

	after_validation :set_defaults

	validates :name, :presence => true
	validates :question, :presence => true

	def self.abimotto
		polls = Poll.where(name: "Abimotto").map do |poll|
			Poll.connection.select_all("select o.name, count(v.id) as votes from poll_options o inner join poll_votes v on o.id = v.poll_option_id where o.poll_id = #{poll.id} group by o.name order by votes desc").to_a
		end
		combined = (polls[0] + polls[1]).each_with_object({}) do |e,h|
			h[e["name"]] ||= 0
			h[e["name"]] += e["votes"].to_i
		end
		sorted = Hash[combined.sort_by{ |_,v| -v }]
		sorted.merge({"Abgegebene Stimmen" => ((sorted.values.sum/2).to_s + " * 2")}).each do |k,v|
			puts k + ": " + v.to_s
		end
	end

	private
		def set_defaults
			self.closed ||= false
			self.public_addable_options ||= false
		end

end
