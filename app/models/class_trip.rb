class ClassTrip < ActiveRecord::Base

  scope :by, ->(sender) { where(sender_id: sender.id) }

  belongs_to :sender, class_name: "Student"
  validates :sender_id, :course, :text, presence: true

end
