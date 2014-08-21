# encoding: utf-8
class Student < ActiveRecord::Base

	# attributes: name, gender, mail_address, (password), (password_confirmation), password_digest, password_resetkey, admin_permissions, closed

	has_secure_password validations: false

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote"
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	has_many :descriptions, foreign_key: "described_id"
	has_many :written_descriptions, class_name: "Description", foreign_key: "author_id"

	has_many :logins, class_name: "Login", foreign_key: "user_id"

	# einträge lassen sich bei before_validation oder before_save seltsamerweise nicht speichern! hat vermutlich was mit has_secure_password zu tun
	after_validation :set_defaults
	before_create { generate_token(:auth_token) }

	scope :name_search, ->(name = "") { where("lower(name) LIKE ?", "%#{name.downcase}%") unless name.empty? }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }
	scope :online, -> { where("last_seen_at > ?", 10.minutes.ago)}

	validates :name, :mail_address, presence: true

	def self.authenticate(mail_address, password)
		student = self.find_by(mail_address: mail_address)
		return student.present? && student.authenticate(password).present?
	end

	def online?
		if self.last_seen_at != nil
			if self.updated_at > 10.minutes.ago
				return true
			else
				return false
			end
		else
			return false
		end
	end

	def male
		self.gender
	end

	def female
		!self.gender
	end

	def send_password_help_mail
		generate_token :password_reset_token
		self.password_reset_sent_at = Time.now
		save!
		StudentMailer.password_reset(self).deliver
	end

	def send_launch_info_mail
		generate_token :password_reset_token
		self.password_reset_sent_at = nil
		save!
		StudentMailer.launch_info(self).deliver
		puts "[#{Time.now}] Launch info mail has been sent to " + self.name
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
