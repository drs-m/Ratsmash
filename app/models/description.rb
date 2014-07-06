# encoding: utf-8
class Description < ActiveRecord::Base

    scope :accepted, -> { where status: 1 }
    scope :rejected, -> { where status: -1 }
    scope :unchecked, -> { where status: 0 }

    belongs_to :author, class_name: "Student"
    belongs_to :described, class_name: "Student"

    validates :content, :hobbies, :interests, :author_id, :described_id, presence: true
	
end
