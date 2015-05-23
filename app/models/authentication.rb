class Authentication < ActiveRecord::Base
  PROVIDER_TYPE = [ 'wechat' ]

  belongs_to :user

  validates :uid, presence: true
  validates :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }
end
