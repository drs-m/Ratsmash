class PollVote < ActiveRecord::Base

	belongs_to :voter, class_name: "Student", foreign_key: "student_id"
	belongs_to :option, class_name: "PollOption", foreign_key: "poll_option_id"
	delegate :poll, to: :option, :allow_nil => true

	validates :student_id, :poll_option_id, presence: true

end
