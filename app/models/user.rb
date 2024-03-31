class User < ActiveRecord::Base
  has_many :posts
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end