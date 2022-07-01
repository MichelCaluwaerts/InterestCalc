class Payment < ApplicationRecord
  belongs_to :account
  validates :date, presence: { message: "à compléter" }
  validates :amount, presence: { message: "à compléter" }
  validate :compare
  def compare
    if account.date.present? && date > account.date
      errors.add(:date, "postérieure à la date du décompte")
    end
  end
  scope :endperiod, ->(period) { find_by("date = ?", (period.date_fin).to_s) }
end
