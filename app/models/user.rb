class User < ApplicationRecord
  ############################################################################################
  ## PeterGate Roles                                                                        ##
  ## The :user role is added by default and shouldn't be included in this list.             ##
  ## The :root_admin can access any page regardless of access settings. Use with caution!   ##
  ## The multiple option can be set to true if you need users to have multiple roles.       ##
  petergate(roles: [:site_admin], multiple: false)                                      ##
  ############################################################################################ 

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :omniauthable, omniauth_providers: [:facebook]

  validates_presence_of :name

  has_many :comments, dependent: :destroy
  has_many :skills, dependent: :destroy

  has_many :like_joins
  has_many :like_blogs, through: :like_joins, source: :likable, source_type: 'Blog'

  has_many :like_joins
  has_many :like_topics, through: :like_joins, source: :likable, source_type: 'Topic'

  has_many :like_joins
  has_many :like_portfolios, through: :like_joins, source: :likable, source_type: 'Portfolio'

  has_many :like_joins
  has_many :like_comments, through: :like_joins, source: :likable, source_type: 'Comment'

  accepts_nested_attributes_for :skills, allow_destroy: true, reject_if: lambda { |attrs| attrs['title'].blank? }

  def first_name
    self.name.split.first
  end

  def last_name
    self.name.split.last
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end
end
