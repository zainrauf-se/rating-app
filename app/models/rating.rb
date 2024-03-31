class Rating < ActiveRecord::Base
  belongs_to :post
  validates :value, inclusion: { in: 1..5 }
end