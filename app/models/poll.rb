class Poll < ActiveRecord::Base
	has_many :poll_options, :dependent => :destroy
	has_many :poll_votes, :dependent => :destroy

	validates :name, :presence => true
	validates :question, :presence => true
end