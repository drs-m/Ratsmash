class Group < ActiveRecord::Base

	has_many :categories

	after_validation :save_defaults

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
