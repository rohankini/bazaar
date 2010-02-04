Factory.define :company do |c|
  c.name Faker::Lorem::words(10)
end

Factory.define :item do |u|
  u.model Faker::Lorem::words
  u.company {|company| company.association(:company) }
end