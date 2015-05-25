class Login < ActiveRecord::Base

    scope :last_hour, -> { where "created_at > ?", 1.hour.ago }
    scope :last_day, -> { where "created_at > ?", 1.day.ago }
    scope :last_week, -> { where "created_at > ?", 1.week.ago }
    scope :last_month, -> { where "created_at > ?", 1.month.ago }
    scope :today, -> { where "created_at > ?", Date.today }

	belongs_to :student, foreign_key: "user_id"

    def to_s
        self.student.name + " -> " + self.created_at.to_s(:timeday)
    end

end
