class Ticket < ActiveRecord::Base

  validates :type_1, numericality: { greater_than_or_equal_to: 0, message: "Du kannst keine negative Anzahl angeben" }
  validates :type_2, numericality: { greater_than_or_equal_to: 0, message: "Du kannst keine negative Anzahl angeben" }

  belongs_to :student

  def to_s
      "#{self.student.name}: #{self.type_1} Laufkarten und #{self.type_2} Buffetkarten"
  end

end
