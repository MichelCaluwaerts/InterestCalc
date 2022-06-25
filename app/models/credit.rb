class Credit < ApplicationRecord
  belongs_to :account
  validates :date, presence: { message: "à compléter" }
  validates :amount, presence: { message: "à compléter" }
  scope :inperiod, ->(period) { where("date BETWEEN ? AND ?", period.date, period.date_fin - 1) }
end
