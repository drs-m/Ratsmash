# encoding: utf-8
class Description < ActiveRecord::Base

    scope :accepted, -> { where status: 1 }
    scope :rejected, -> { where status: -1 }
    scope :unchecked, -> { where status: 0 }

    belongs_to :author, class_name: "Student"
    belongs_to :described, class_name: "Student"

    validates :author_id, :described_id, :content, :hobbies, :interests, :additional_authors, presence: true
    validate :no_self_description

    after_validation :set_defaults

    private
        def set_defaults
            self.status ||= 0
        end

        def no_self_description
            errors.add(:described_id, "Du darfst keine Beschreibung für dich selbst einreichen") if self.author_id == self.described_id
        end

end
