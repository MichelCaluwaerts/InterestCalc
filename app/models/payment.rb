class Payment < ApplicationRecord
  belongs_to :account
  validates :date, presence: { message: "à compléter" }
  validates :amount, presence: { message: "à compléter" }
  scope :endperiod, ->(period) { find_by("date = ?", (period.date_fin).to_s) }
end
