# encoding: utf-8
class Category < ActiveRecord::Base

	has_many :votes
	belongs_to :group

	validates :name, presence: true

end
