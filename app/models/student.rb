class Student < ActiveRecord::Base

	# attributes: name, gender, mail_address, (password), (password_confirmation), password_digest, password_resetkey, admin_permissions

	has_secure_password

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote"
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	# einträge lassen sich bei before_validation oder before_save seltsamerweise nicht speichern! hat vermutlich was mit has_secure_password zu tun
	after_validation :set_defaults

	scope :name_search, ->(name = "") { where("name LIKE ?", "%#{name}%") unless name.empty? }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }

	private
		def set_defaults
			self.admin_permissions ||= false
			self.closed ||= false
		end

end
