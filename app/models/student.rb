class Student < ActiveRecord::Base

	# attributes: name, gender, mail_address, (password), (password_confirmation), password_digest, password_resetkey, admin_permissions

	has_secure_password

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote"
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	# einträge lassen sich bei before_validation oder before_save seltsamerweise nicht speichern! hat vermutlich was mit has_secure_password zu tun
	after_validation :set_defaults
	before_create { generate_token(:auth_token) }

	scope :name_search, ->(name = "") { where("name LIKE ?", "%#{name}%") unless name.empty? }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }

	validates :name, :mail_address, presence: true

	def send_password_reset
		generate_token :password_reset_token
		self.password_reset_sent_at = Time.now
		save!
		StudentMailer.password_reset(self).deliver
	end	

	private
		def set_defaults
			self.admin_permissions ||= false
			self.closed ||= false
		end

		def generate_token(column)
	    	begin
    	  		self[column] = SecureRandom.urlsafe_base64
    		end while Student.exists?(column => self[column])
  		end

end
