ActionController::Routing::Routes.draw do |map|
  map.resources :items
  
  map.root :items
  
end
