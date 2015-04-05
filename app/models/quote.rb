class Quote < ActiveRecord::Base

	validates :text, presence: true
	after_validation :set_defaults

	def to_s
		out = "ID: #{self.id}\n"
		out += "Absender: #{self.sender}\n" + self.text
		out
	end

	private
		def set_defaults
			self.teacher ||= false
			self.sender = "Anonym" if self.sender.blank?
		end

end
