class Company < ActiveRecord::Base
  has_many :items
end