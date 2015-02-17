class PollVote < ActiveRecord::Base

	belongs_to :voter, class_name: "Student", foreign_key: "student_id"
	belongs_to :option, class_name: "PollOption", foreign_key: "poll_option_id"
	delegate :poll, to: :option, :allow_nil => true

	scope :for, ->(option) { where(poll_option_id: option.id) }
	scope :by, ->(user) { where(student_id: user.id) }

	validates :student_id, :poll_option_id, presence: true

end
