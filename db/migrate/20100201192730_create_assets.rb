class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets, :force => true do |t|
      t.string :data_file_name, :data_content_type, :data_file_size, :data_updated_at
      t.references :attachable, :polymorphic => true 
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
