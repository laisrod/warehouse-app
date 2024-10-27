require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    # Arrange
    User.create!( email: 'joaogomes@email.com', password: 'password')

    # Act
    visit root_path
    click_on 'Entrar'
    # Adicionando uma espera explícita
    expect(page).to have_selector('#formulario-login')
    within('#formulario-login') do
      fill_in 'E-mail', with: 'joaogomes@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    
    # Assert
    expect(page).to have_content 'Login efetuado com sucesso' # Verifique se a mensagem de sucesso aparece
    expect(page).not_to have_link 'Entrar'
    expect(page).to have_button 'Sair'
    expect(page).to have_content 'joaogomes@email.com'
  end

  it 'e faz logout' do
    # Arrange
    User.create!(email: 'joaopedro@email.com', password: 'password')

    # Act
    visit root_path
    click_on 'Entrar'
    fill_in 'E-mail', with: 'joaopedro@email.com'
    fill_in 'Senha', with: 'password'
    within('#Entrar') do  
      click_on 'Entrar'
    end
    click_on 'Sair'

    save_and_open_page # Verifique a saída após o logout
  
    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'joaopedro@email.com'
  end
end
