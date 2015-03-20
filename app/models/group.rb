class Group < ActiveRecord::Base

	has_many :categories

	after_validation :save_defaults

	scope :everyone, -> { where(female: true, male: true, student: true, teacher: true).first }
	scope :all_female, -> { where(female: true, male: false, student: true, teacher: true).first }
	scope :all_male, -> { where(female: false, male: true, student: true, teacher: true).first }
	scope :all_students, -> { where(female: true, male: true, student: true, teacher: false).first }
	scope :all_teachers, -> { where(female: true, male: true, student: false, teacher: true).first }
	scope :female_students, -> { where(female: true, male: false, student: true, teacher: false).first }
	scope :male_students, -> { where(female: false, male: true, student: true, teacher: false).first }
	scope :female_teachers, -> { where(female: true, male: false, student: false, teacher: true).first }
	scope :male_teachers, -> { where(female: false, male: true, student: false, teacher: true).first }

	scope :student_categories, -> { Category.where(group_id: Group.where(student: true).ids) }
	scope :teacher_categories, -> { Category.where(group_id: Group.where(teacher: true).ids) }

	def active_filters
		filters_to_return = []
		@@used_filters.each { |filter| filters_to_return << filter if self[filter] }
		return filters_to_return
	end

	private
		def save_defaults
			self.female ||= false
			self.male ||= false
			self.student ||= false
			self.teacher ||= false
		end

end
