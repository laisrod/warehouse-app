class OrdemItem < ApplicationRecord
  belongs_to :product_model
  belongs_to :order
end
