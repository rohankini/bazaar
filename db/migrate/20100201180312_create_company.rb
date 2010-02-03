class CreateCompany < ActiveRecord::Migration
  def self.up
    create_table :companies, :force => true do |t| 
      t.text :name
      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
