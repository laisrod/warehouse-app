class RemoveWahehouses < ActiveRecord::Migration[7.2]
  def change
    drop_table :wahehouses
  end
end
