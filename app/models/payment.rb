class Payment < ApplicationRecord
  belongs_to :account
  scope :endperiod, ->(period) { find_by("date = ?", (period.date_fin).to_s) }
end
