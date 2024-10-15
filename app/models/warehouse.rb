class Warehouse < ApplicationRecord
    validates :name, :code, :description, :address, 
              :city, :cep, :area, presence: true
end
