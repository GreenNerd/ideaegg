class Feedback < ActiveRecord::Base
  belongs_to :product

  validates :product_id, presence: true
  validates :body, presence: true
  validates :stars, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
end
