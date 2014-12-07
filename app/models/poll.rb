class Poll < ActiveRecord::Base
	has_many :poll_options, :dependent => :destroy
	has_many :poll_votes, :dependent => :destroy

	after_validation :set_defaults

	validates :name, :presence => true
	validates :question, :presence => true

	private
		def set_defaults
			self.closed ||= false
		end

end