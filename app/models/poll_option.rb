class PollOption < ActiveRecord::Base
	belongs_to :poll
	has_many :poll_votes, :dependent => :destroy

	validates :poll_id, :presence => true
	validates :name, :presence => true
end
