class Account < ApplicationRecord
  belongs_to :user
  has_many :credits, dependent: :destroy
  accepts_nested_attributes_for :credits, allow_destroy: true, reject_if: all.blank?
  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments, allow_destroy: true, reject_if: all.blank?
  has_many :costs, dependent: :destroy
  accepts_nested_attributes_for :costs, allow_destroy: true, reject_if: all.blank?
  has_many :capitalisations, dependent: :destroy
  accepts_nested_attributes_for :capitalisations, allow_destroy: true, reject_if: all.blank?
  has_many :periods, dependent: :destroy
  has_many :rates, through: :periods

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :date, presence: true
  validates :name, presence: true
  validate :verif
  def verif
    if credits.empty?
      errors.add(:int_type, :credit_missing)
    end
  end
  INT_TYPE = [["conventionnel", "Conventionnel"], ["commercial", "Commercial"], ["civil", "Civil"]]
end
