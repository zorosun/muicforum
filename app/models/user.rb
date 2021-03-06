class User < ActiveRecord::Base
	acts_as_tagger
	acts_as_voter
	mount_uploader :avatar, AvatarUploader

	has_secure_password
	has_many :topics, dependent: :destroy
	has_many :comments , dependent: :destroy
	before_save { email.downcase! }
	before_create :create_remember_token
	validates(:name, presence: true, length: { maximum: 50})
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates(:email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false})
	validates(:password, length: {minimum: 6})

	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.encrypt(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

  	def self.usersearch(usersearch)
		if usersearch  
	    	where('name LIKE ?', "%#{usersearch}%")  
	    else  
	     	scoped  
	  	end  
	end

  	private

	    def create_remember_token
	      self.remember_token = User.encrypt(User.new_remember_token)
	    end
end
