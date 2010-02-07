ActionController::Routing::Routes.draw do |map|
  map.resources :items, :collection => {:filter => :get}
  map.root :items
end
