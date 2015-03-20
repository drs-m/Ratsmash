# encoding: utf-8
class CategoryResult

    attr_accessor :category, :ranking, :sum_points

    def self.for_student(student)
      winnings = []
      Group.student_categories.find_each do |category|
        category.result.ranking.each do |rank|
          if rank.name == student.name
            winnings << { :name => category.name, :rank => rank.number }
          end
        end
      end

      winnings
    end

    def initialize(category)
        @category = category
        if category.group.student && !category.group.teacher
			table = "students"
		elsif category.group.teacher && !category.group.student
			table = "teachers"
		else
			return nil
		end

        @sum_points = category.votes.sum(:rating).to_f
		ranking = Category.connection.select_all("select name, sum(rating) as points from votes inner join #{table} on votes.voted_id = #{table}.id where votes.category_id = #{category.id} group by name order by points desc limit 3").to_a
        @ranking = ranking.empty? ? [] : Array.new(ranking.count).map.with_index { |e, i| Rank.new(i+1, ranking[i], ((ranking[i]["points"].to_i/@sum_points).round(2) * 100).to_i) }
    end

    def to_s
        out = "(#{@category.group.name} / #{@category.votes.count} Stimmen) #{@category.name}: \n"
        out += @ranking.map(&:to_s).join("\n")
        out + "\n\n"
    end

end
