class Item < ActiveRecord::Base
  belongs_to :company
  has_many :assets, :as => :attachable, :dependent => :destroy
  
  # acts_as_taggable_on :city
end