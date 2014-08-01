# encoding: utf-8
class Category < ActiveRecord::Base

	after_validation :set_defaults

	has_many :votes
	belongs_to :group

	validates :name, :group_id, presence: true

	private
		def set_defaults
			self.closed ||= false
		end

end
