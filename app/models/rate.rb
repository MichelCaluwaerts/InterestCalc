class Rate < ApplicationRecord
  has_many :periods
  has_many :accounts, through: :periods
end
