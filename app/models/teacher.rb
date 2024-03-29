class Teacher < ActiveRecord::Base

	has_many :achieved_votes, class_name: "Vote", :as => :voted

	after_validation :set_defaults

	scope :name_search, ->(name = "") { where("lower(name) LIKE ?", "%#{name.downcase}%") unless name.empty? }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }

	validates :name, presence: true

    def winnings
        CategoryResult.all_for self
    end

	def male
		self.gender
	end

	def female
		!self.gender
	end

	private
			def set_defaults
				self.closed ||= false
			end

end
