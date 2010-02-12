namespace :db do
  task :unload => :environment do
    Company.delete_all
    Item.all.each(&:destroy)
  end

  task :load => [:environment, :drop, :create, :migrate, :unload] do
    require 'populator'

    Builder::create_users
    Builder::create_companies
    Builder::create_items
  end
end

module Builder
  def self.create_users
    User.create! :email => 'rohan.kini@gmail.com', :password => 'password', :password_confirmation => 'password'
  end
  
  def self.create_companies
    Company.populate(5) do |company|
      company.name = ['Trek', 'Cannondale', 'Merida', 'Kona', 'Giant']
    end
  end

  def self.create_items
    Item.populate(10) do |item|
      item.description = Populator.words(10..20)
      item.company_id = Company.find(:first, :offset => rand(Company.count)).id
      item.model = ['4300', 'F4', 'innova', '6000', 'F9', '5.2', 'Madone 5.5']
      item.color = ['red', 'blue', 'green', 'pink']
      item.bought_on = Time.now
      item.price = ['Rs. 10,000', 'Rs. 20,000', 'Rs. 2,34,434', 'Rs. 11,221']

      item.owner_name = Faker::Name.name
      item.email = Faker::Internet.email
      item.phone_number = Faker::PhoneNumber.phone_number

      item.city = ['Bangalore', 'Delhi', 'Mumbai']
      item.state = ['Karnataka', 'Kerala']
      item.address = Populator.words(10..20)
    end
    Item.all.each {|i| i.assets << Asset.new(:data => File.open(random_bike_image)) }
  end

  BASE_DIR = File.join(RAILS_ROOT, 'lib', 'tasks', 'bikes', '*.jpg')
  def self.random_bike_image
    Dir.glob(BASE_DIR).rand  
  end
end