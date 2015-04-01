# encoding: utf-8
class Description < ActiveRecord::Base

    attr_accessor :described_name

    scope :accepted, -> { where status: 1 }
    scope :rejected, -> { where status: -1 }
    scope :unchecked, -> { where status: 0 }

    scope :by, ->(author) { where author_id: author.id }

    belongs_to :author, class_name: "Student"
    belongs_to :described, class_name: "Student"

    validate :valid_and_strange_student # wandle schülernamen in id um
    validates :author_id, :content, :hobbies, :interests, presence: true

    after_validation :set_defaults

    def to_s
      out = "Von #{self.author.name} an #{self.described.name}\n"
      out += "Weitere Autoren: #{self.additional_authors}\n"
      out += "Interessen: #{self.interests}\n"
      out += "Hobbies: #{self.hobbies}\n"
      out += "Text:\n"
      out += self.content
      out
    end

    private
        def set_defaults
            self.status ||= 0
        end

        def valid_and_strange_student
            return if self.described_id.present?
            search_result = Student.where("lower(name) LIKE ?", self.described_name.downcase)

            errors.add(:described_name, "Es wurden mehrere Einträge für diesen Namen gefunden... Das ist nicht vorgesehen.") if search_result.count > 1

            self.described = search_result.first
            if self.described.blank?
                errors.add(:described_name, "Der Schüler '#{self.described_name}' wurde nicht gefunden!")
            else
                errors.add(:described_id, "Du darfst keine Beschreibung für dich selbst einreichen") if self.described == Student.find(self.author_id)
            end
        end

end
