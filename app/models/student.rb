# encoding: utf-8
class Student < ActiveRecord::Base

	# attributes: name, gender, mail_address, (password), (password_confirmation), password_digest, password_resetkey, admin_permissions, closed

	has_secure_password validations: false

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote", dependent: :destroy
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	has_many :descriptions, foreign_key: "described_id", dependent: :destroy
	has_many :written_descriptions, class_name: "Description", foreign_key: "author_id"

	has_many :logins, class_name: "Login", foreign_key: "user_id"

	has_many :memberships, dependent: :destroy, foreign_key: "member_id"
	has_many :groups, through: :memberships

	# einträge lassen sich bei before_validation oder before_save seltsamerweise nicht speichern! hat vermutlich was mit has_secure_password zu tun
	after_validation :set_defaults
	before_create { generate_token(:auth_token) }

	scope :name_search, ->(name = "") { where("lower(name) LIKE ?", "%#{name.downcase}%") unless name.empty? }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }
	scope :online, -> { where("last_seen_at > ?", 10.minutes.ago)}
	scope :active, -> { where.not(password_digest: nil) }
	scope :inactive, -> { where password_digest: nil }

	validates :name, :mail_address, presence: true

	def self.authenticate(mail_address, password)
		student = self.find_by(mail_address: mail_address)
		return student.present? && student.authenticate(password).present?
	end

	def has_permission(*permissions)
		results = []
		permissions.each_with_index do |permission, i|
			child_permission = permission
			parent_permission = child_permission.split(".")[0...-1].join(".").+(".*")

			[child_permission, parent_permission, "*"].each do |permission|
				if self.groups.map(&:permissions).flatten.include?(permission)
					results[i] = true
					break
				else
					results[i] = false
				end
			end
		end

		return (results.include?(false) ? false : true)
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

	def complete_voted_categories
		categories = []
		self.given_votes.each do |vote|
			if self.given_votes.where(:category_id => vote.category_id).count >= 3
				if !categories.include? vote.category
					categories << vote.category.id
				end
			end
		end

		return categories
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
		puts "[#{Time.now}] Registrierungsmail wurde an #{self.name} verschickt"
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
