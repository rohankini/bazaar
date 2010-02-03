class CreateItem < ActiveRecord::Migration
  def self.up
    create_table :items, :force => true do |t| 
      t.text :description
      t.references :company
      t.string :model, :color
      t.date :bought_on
    
      t.string :price, :permalink
      
      t.string :owner_name, :email, :phone_number
      t.string :city, :state, :address

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end
