class Poll < ActiveRecord::Base

	has_many :options, class_name: "PollOption", :dependent => :destroy
	has_many :votes, class_name: "PollVote", through: :options

	scope :voted_for, ->(student) { where id: student.poll_votes.map(&:poll).map(&:id) }
	scope :not_voted_for, ->(student) { where.not id: voted_for(student).ids }
	scope :closed, -> { where closed: true }
	scope :open, -> { where closed: false }

	after_validation :set_defaults

	validates :name, :presence => true
	validates :question, :presence => true

	def results
		Poll.connection.select_all("select o.name, count(v.id) as votes from poll_options o inner join poll_votes v on o.id = v.poll_option_id where o.poll_id = #{self.id} group by o.name order by votes desc").to_a
	end

	def self.abimotto(print = true)
		polls = Poll.where(name: "Abimotto Vorentscheid").map do |poll|
			poll.results
		end

		combined = (polls[0] + polls[1]).each_with_object({}) do |e,h|
			h[e["name"]] ||= 0
			h[e["name"]] += e["votes"].to_i
		end
		sorted = Hash[combined.sort_by{ |_,v| -v }]
		if print
			sorted.merge({"Abgegebene Stimmen" => ((sorted.values.sum/2).to_s + " * 2")}).each do |k,v|
				puts k + ": " + v.to_s
			end
		end
	end

	private
		def set_defaults
			self.closed ||= false
			self.public_addable_options ||= false
		end

end
