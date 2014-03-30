# encoding: utf-8
class Category < ActiveRecord::Base

	has_many :votes

	before_save :default_values

	def apply_to(selected_group)
		if (selected_group)
			groups_with_members = { :all => [:male, :female, :student, :teacher], 
						 :all_female => [:female, :student, :teacher], 
						 :all_male => [:male, :student, :teacher], 
						 :all_students => [:female, :male, :student],
						 :all_teachers => [:female, :male, :teacher],
						 :female_students => [:female, :student],
						 :male_students => [:male, :student],
						 :female_teachers => [:female, :teacher],
						 :male_teachers => [:male, :teacher] }

			db_types = [:female, :male, :student, :teacher]
			members_to_set = groups_with_members[selected_group]
			if members_to_set
				db_types.each { |db_type| self[db_type] = members_to_set.include?(db_type) ? true : false }
				return save
			end
			return false
		end
	end

	private
		def default_values
			self.female = false if self.female.nil?
			self.male = false if self.male.nil?
			self.student = false if self.student.nil?
			self.teacher = false if self.teacher.nil?
		end

end
