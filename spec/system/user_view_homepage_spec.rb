require 'rails_helper'

describe 'Usuario visita tela inicial' do
  it 'e vê o nome da app' do
    # Arrange 

    # Act
    visit(root_path)

    # Assert
    expect(page).to have_content('Galpões e Estoque')
    expect(page).to have_link('Galpões e Estoque', href: root_path)
  end

  it 'e vê os galpoes cadastrados' do
    # Arrange
    Warehouse.create!(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000,
                    address: 'Avenida do Museu do Amanhã, 1000', cep: '20100-000',
                    description: 'Galpão do Rio')
    Warehouse.create!(name: 'Maceio', code: 'MCD', city: 'Maceio', area: 50_000,
                    address: 'Avenida do Aeroporto, 1000', cep: '57050-000',
                    description: 'Galpão de Maceio')
  
    # Act
    visit root_path

    # Assert
    expect(page).not_to have_content('Não existem galpões cadastrados')
    expect(page).to have_content("Rio")
    expect(page).to have_content("SDU")
    expect(page).to have_content("Rio de Janeiro")
    expect(page).to have_content("60000 m²")
    expect(page).to have_content("Maceio")
    expect(page).to have_content("MCD") 
    expect(page).to have_content("50000 m²") 
  end

  it 'e não existem galpões cadastrados' do
    # Arrange
    
    # Act
    visit(root_path)

    # Assert
    expect(page).to have_content('Não existem galpões cadastrados')
  end

  it 'e vê detalhes de um galpão' do
    # Arrange   
    Warehouse.create(name: 'Rio', code: 'SDU', city: 'Rio de Janeiro', area: 60_000, 
                    description: 'Galpão do Rio', address: 'Avenida do Museu do Amanhã, 1000', cep: '20100-000')

    # Act
    visit(root_path)

    # Assert
    expect(page).to have_content("Rio")
    expect(page).to have_content("SDU")
  end
end