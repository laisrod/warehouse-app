class Order < ApplicationRecord
  belongs_to :warehouse
  belongs_to :supplier
  belongs_to :user
  has_many :order_items
  has_many :stock_products

  enum status: { pending: 0, delivered: 1, canceled: 2 }

  validates :code, presence: true, uniqueness: true
  validates :estimated_delivery_date, presence: true
  validate :estimated_delivery_date_is_future, on: :create

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def estimated_delivery_date_is_future
    if self.estimated_delivery_date.present? && self.estimated_delivery_date <= Date.today
      errors.add(:estimated_delivery_date, " deve ser futura.")
    end
  end
end