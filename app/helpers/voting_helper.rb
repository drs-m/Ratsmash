# encoding: utf-8
module VotingHelper

	def filter_description_for_category(category)
		return ""
		text = "("
		category.active_filters.each do |active_filter|
			case active_filter
			when :female
				text += "weibliche "
			when :male
				text += "männliche "
			when :student
				text += "Schüler / "
			when :teacher
				text += "Lehrer / "
			end
		end
		text += ")"
		return text
	end

end
