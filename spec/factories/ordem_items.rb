FactoryBot.define do
  factory :ordem_item do
    product_model { nil }
    order { nil }
    quantity { 1 }
  end
end
