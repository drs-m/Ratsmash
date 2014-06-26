class Quote < ActiveRecord::Base

	validates :sender, :text, presence: true

end
