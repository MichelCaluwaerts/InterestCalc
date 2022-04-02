class Cost < ApplicationRecord
  belongs_to :account
  scope :inperiod, ->(period) { where("date BETWEEN ? AND ?", period.date, period.date_fin) }
end
