class PollVote < ActiveRecord::Base
	belongs_to :poll
	belongs_to :poll_option
	belongs_to :student
	
	validates :poll_id, :presence => true
	validates :poll_option_id, :presence => true
end