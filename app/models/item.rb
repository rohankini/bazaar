class Item < ActiveRecord::Base
  belongs_to :company
  has_many :assets, :as => :attachable, :dependent => :destroy

end