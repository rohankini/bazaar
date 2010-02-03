namespace :db do
  task :unload => :environment do
    Company.delete_all
    Item.all.each(&:destroy)
  end

  task :load => [:environment, :drop, :create, :migrate, :unload] do
    require 'populator'

    Builder::create_companies
    Builder::create_items
  end
end

module Builder
  def self.create_companies
    Company.populate(2) do |company|
      company.name = ['Trek', 'Cannondale', 'Merida', 'Kona', 'Giant']
    end
  end

  def self.create_items
    Item.populate(10) do |item|
      item.description = Populator.words(10..20)
      item.company_id = rand(Company.count)
      item.model = Populator.words(2)
      item.color = ['red', 'blue', 'green', 'pink']
      item.bought_on = Time.now
      item.price = ['10000', '20000', '234434', '11221']

      item.owner_name = Faker::Name.name
      item.email = Faker::Internet.email
      item.phone_number = Faker::PhoneNumber.phone_number

      item.city = Faker::Address.city
      item.state = Faker::Address.us_state
      item.address = Populator.words(10..20)
    end
    Item.all.each {|i| i.assets << Asset.new(:data => File.open(random_bike_image)) }
  end

  BASE_DIR = File.join(RAILS_ROOT, 'lib', 'tasks', 'bikes', '*.jpg')
  def self.random_bike_image
    Dir.glob(BASE_DIR).rand  
  end
end