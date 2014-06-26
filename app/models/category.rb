# encoding: utf-8
class Category < ActiveRecord::Base

	after_validation :set_defaults

	has_many :votes
	belongs_to :group

	validates :name, presence: true

	private
		def set_defaults
			self.locked ||= false
		end

end
