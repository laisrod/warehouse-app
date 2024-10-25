class Order < ApplicationRecord
  belongs_to :warehouse
  belongs_to :supplier
  belongs_to :user

  before_validation :generate_code, on: :create

  validates :code, presence: true, uniqueness: true
  validates :estimated_delivery_date, presence: true
  validate :estimated_delivery_date_is_future

  private

  def generate_code
    self.code ||= SecureRandom.alphanumeric(8).upcase
  end

  def estimated_delivery_date_is_future
    if estimated_delivery_date.present? && estimated_delivery_date <= Date.today
      errors.add(:estimated_delivery_date, "deve ser futura")
    end
  end
end
