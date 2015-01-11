class PollOption < ActiveRecord::Base

	belongs_to :poll
	has_many :votes, class_name: "PollVote", :dependent => :destroy

	validates :name, :poll, presence: true

end
