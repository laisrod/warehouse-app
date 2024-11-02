class CreateOrdemItems < ActiveRecord::Migration[7.2]
  def change
    create_table :ordem_items do |t|
      t.references :product_model, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
