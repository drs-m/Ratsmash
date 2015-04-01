class Quote < ActiveRecord::Base

	validates :text, presence: true
	after_validation :set_defaults

	def to_s
		"Absender: #{self.sender}\n" + self.text
	end

	private
		def set_defaults
			self.teacher ||= false
			self.sender ||= "Anonym"
		end

end
