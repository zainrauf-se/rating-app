class Post < ActiveRecord::Base
  belongs_to :user
  has_many :ratings
  validates :title, :content, presence: true
end