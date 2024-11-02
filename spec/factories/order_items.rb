FactoryBot.define do
  factory :order_item do
    order { nil }
    product_model { nil }
    quantity { 1 }
  end
end
