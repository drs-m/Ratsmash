# encoding: utf-8
class Rank
    attr_accessor :number, :name, :points, :percentage

    def initialize(number, data, percentage)
        @number = number
        @name = data["name"]
        @points = data["points"]
        @percentage = percentage
    end

    def to_s
        "#{self.number}. #{self.name} (#{self.percentage}%)"
    end
end
