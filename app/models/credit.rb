class Credit < ApplicationRecord
  belongs_to :account
  validates :date, presence: { message: "à compléter" }
  validates :amount, presence: { message: "à compléter" }
  validate :compare
  def compare
    if account.date.present? && date > account.date
      errors.add(:date, "postérieure à la date du décompte")
    end
  end
  scope :inperiod, ->(period) { where("date BETWEEN ? AND ?", period.date, period.date_fin - 1) }
end
