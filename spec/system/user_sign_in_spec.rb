require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    # Arrange
    User.create!(email: 'joao@email.com', password: 'password')

    #Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'joao@email.com'
    fill_in 'Senha', with: 'password'
    click_on 'Entrar'

    #Assert
    expect(page).not_to have_link 'Entrar'
    expect(page).to have_link 'Sair'
    within('nav') do
      expect(page).to have_content 'joao@email.com'
    end
    #Espera ver uma mensagem de sucesso => usuário autenticado com sucesso.
  end
end