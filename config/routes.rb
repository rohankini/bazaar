ActionController::Routing::Routes.draw do |map|
  map.resources :items, :collection => {:filter => :post}
  map.root :items
end
