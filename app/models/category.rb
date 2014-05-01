# encoding: utf-8
class Category < ActiveRecord::Base

	has_many :votes

	before_save :default_values

	# simple scopes for vote controller
	scope :female, -> { where female: true, male: false }
	scope :male, -> { where male: true, female: false }
	scope :unisex, -> { where female: true, male: true }
	scope :student, -> { where student: true, teacher: false }
	scope :teacher, -> { where teacher: true, student: false }
	scope :unigroup, -> { where student: true, teacher: true }

	@@groups_with_filters = { :all => [:male, :female, :student, :teacher], 
						 :all_female => [:female, :student, :teacher], 
						 :all_male => [:male, :student, :teacher], 
						 :all_students => [:female, :male, :student],
						 :all_teachers => [:female, :male, :teacher],
						 :female_students => [:female, :student],
						 :male_students => [:male, :student],
						 :female_teachers => [:female, :teacher],
						 :male_teachers => [:male, :teacher] }

	@@db_filters = [:female, :male, :student, :teacher]

	def active_filters
		filters_to_return = []
		@@db_filters.each { |filter| filters_to_return << filter if self[filter] }
		return filters_to_return
	end

	def apply_to(selected_group)
		if (selected_group)
			filters_to_set = @@groups_with_filters[selected_group]
			if filters_to_set
				@@db_filters.each { |db_filter| self[db_filter] = filters_to_set.include?(db_filter) ? true : false }
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
