class Product < ActiveRecord::Base
  has_many :feedbacks, dependent: :destroy
end
