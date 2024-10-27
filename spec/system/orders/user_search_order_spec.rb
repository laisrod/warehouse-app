require 'rails_helper'

describe 'Usuário busca por um pedido' do

    it 'a partir do menu' do
      # Arrange
      user = User.create!(name: 'Joao', email: 'joao@email.com', password: 'password')
      # Act
      login_as(user)
      visit root_path
        
      # Assert
      within('header nav') do
        expect(page).to have_field('Buscar Pedido')
        expect(page).to have_button('Buscar')
      end
    end

end