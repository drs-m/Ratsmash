# encoding: utf-8
class Student < ActiveRecord::Base

	# attributes: name, gender, mail_address, (password), (password_confirmation), password_digest, password_resetkey, admin_permissions, closed

	has_secure_password validations: false

	has_one :ticket

	has_many :given_votes, foreign_key: "voter_id", class_name: "Vote", dependent: :destroy
	has_many :achieved_votes, class_name: "Vote", :as => :voted

	has_many :poll_votes, dependent: :destroy

	has_many :descriptions, foreign_key: "described_id", dependent: :destroy
	has_many :written_descriptions, class_name: "Description", foreign_key: "author_id"

	has_many :child_pics, foreign_key: "sender_id"

	has_many :logins, class_name: "Login", foreign_key: "user_id"

	has_many :memberships, dependent: :destroy, foreign_key: "member_id"
	has_many :groups, through: :memberships

	# einträge lassen sich bei before_validation oder before_save seltsamerweise nicht speichern! hat vermutlich was mit has_secure_password zu tun
	after_validation :set_defaults
	before_create { generate_token(:auth_token) }

	scope :name_search, ->(name = "") { where("lower(name) LIKE ?", "%#{name.downcase}%") unless name.empty? }
	scope :male, -> { where gender: true }
	scope :female, -> { where gender: false }
	scope :online, -> { where("last_seen_at > ?", 5.minutes.ago)}
	scope :active, -> { where.not(password_digest: nil) }
	scope :inactive, -> { where password_digest: nil }

	validates :name, :mail_address, presence: true


	def self.login(email, password)
		if (student = self.find_by mail_address: email).present?
			if password.blank?
				error = "Bitte gib ein Passwort ein!"
			else
				if student.password_digest.present?
					if student.authenticate password
						if student.closed
							return { status: :error, message: "Dein Account wurde gesperrt! Bitte wende dich an die Abizeitung oder das Ratsmash-Team." }
						else
							return { status: :success, user: student }
						end
					else
						return { status: :error, message: "Das eingegebene Passwort ist falsch" }
					end
				else
					return { status: :error, message: "Dein Account wurde noch nicht aktiviert" }
				end

			end
		else
			return { status: :error, message: "Der Account konnte nicht gefunden werden" }
		end
	end

	def self.authenticate(mail_address, password)
		student = self.find_by(mail_address: mail_address)
		return student.present? && student.authenticate(password).present?
	end

	def has_one_of_permissions(*permissions)
		permissions.each { |p| return true if has_permission(p) }

		return false
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
		self.last_seen_at != nil and self.updated_at > 5.minutes.ago
	end

	def male
		self.gender
	end

	def female
		!self.gender
	end

	def winnings
		CategoryResult.all_for self
	end

	# gibt Kategorien nach Anzahl der abgegebenen Stimmen wieder
	def categories_by_vote_count
		self.given_votes.group(:category_id).count.each_with_object({}) { |(k, v), h| ( h[v] ||= [] ) << self.given_votes.find_by(category_id: k) }
	end

	def complete_voted_categories
		categories_by_vote_count[3]
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

	def to_s
		self.name
	end

	def join_group(name)
		if group = UserGroup.where("lower(name) like ?", "%#{name.downcase}%").first
			group.members << self
			puts "Gruppe beigetreten"
		else
			puts "Gruppe nicht gefunden!"
		end
	end

	def leave_group(name)
		if group = UserGroup.where("lower(name) like ?", "%#{name.downcase}%").first
			group.memberships.find_by(member_id: self.id).destroy
			puts "Gruppe verlassen"
		else
			puts "Gruppe nicht gefunden!"
		end
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
