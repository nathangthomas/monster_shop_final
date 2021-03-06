class User < ApplicationRecord
  has_secure_password

  has_many :addresses
  belongs_to :merchant, optional: true
  has_many :orders

  accepts_nested_attributes_for :addresses

  validates_presence_of :name,
                        # :address,
                        # :city,
                        # :state,
                        # :zip,
                        :email

  validates_uniqueness_of :email

  enum role: ['default', 'merchant_admin', 'admin']

end
