class Period < ApplicationRecord
  belongs_to :account
  belongs_to :rate
end
