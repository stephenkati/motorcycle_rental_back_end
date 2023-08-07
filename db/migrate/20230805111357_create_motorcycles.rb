class CreateMotorcycles < ActiveRecord::Migration[7.0]
  def change
    create_table :motorcycles do |t|
      t.string :name
      t.string :photo
      t.integer :purchase_price
      t.integer :rental_price
      t.string :description

      t.timestamps
    end
  end
end
