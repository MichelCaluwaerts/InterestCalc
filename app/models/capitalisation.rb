class Capitalisation < ApplicationRecord
  belongs_to :account
  validate :compare
  def compare
    if account.date.present? && date > account.date
      errors.add(:date, "postérieure à la date du décompte")
    end
  end
end
