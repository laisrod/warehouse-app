FactoryBot.define do
  factory :stock_product do
    warehouse { nil }
    order { nil }
    product_model { nil }
    serial_number { "MyString" }
  end
end
