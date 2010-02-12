ActionController::Routing::Routes.draw do |map|
  map.resources :items, :collection => {:filter => :get}
  map.root :items
  
  map.resource :user_session
  map.resource :account, :controller => "users"
  map.resources :users
end
