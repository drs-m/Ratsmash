class Ticket < ActiveRecord::Base

  validates :amount, numericality: { greater_than_or_equal_to: 0, message: "Du kannst keine negative Anzahl angeben" }

  belongs_to :student

  def to_s
    self.student.name + ": " + self.amount.to_s
  end

end
