ActionController::Routing::Routes.draw do |map|
	#map.resources :users, :has_many => :links

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # On site authentication
  #map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.signup_action '/session/create', :controller => 'session', :action => 'create'
  map.login '/login', :controller => 'session', :action => 'new'                                                   
  map.logout '/logout', :controller => 'session', :action => 'destroy'

  # Flat pages
  map.home '/', :controller => 'home', :action => 'index'
  map.about '/about', :controller => 'home', :action => 'about'
  map.addons '/addons', :controller => 'home', :action => 'addons'
  map.view_link '/view/:id', :controller => 'home', :action => 'view_link'
  map.queue '/queue/:id', :controller => 'home', :action => 'queue'
  
  # API urls
  map.save '/save', :controller => 'links', :action => 'create'
  
  # User pages
  map.user_queue '/my-queue', :controller => 'users', :action => 'queue'
  map.edit_user '/account', :controller => 'users', :action => 'edit'
  map.remote_login '/remote-login/', :controller => 'users', :action => 'remote_get_salt'
  map.remote_queue '/remote-queue/', :controller => 'users', :action => 'remote_get_queue'
  map.remote_create '/remote-create/', :controller => 'users', :action => 'remote_create'
  
  map.create_user '/user',
    :controller => 'users', 
    :action => 'create', 
    :conditions => {:method => :post}
  
  map.edit_user_action '/user', 
    :controller => 'users', 
    :action => 'update', 
    :conditions => {:method => :put}
    
  map.delete_user_action '/user', 
    :controller => 'users', 
    :action => 'delete', 
    :conditions => {:method => :delete}
    
  map.create_user '/user',
    :controller => 'users', 
    :action => 'show', 
    :conditions => {:method => :get}
   
  map.user_links '/user/links', :controller => 'links', :action => 'index'
  
  map.user_create_link '/user/links/create', :controller => 'links', :action => 'create'
  map.delete_link '/user/links/delete/:id', :controller => 'links', :action => 'delete'
  map.link '/view/:id', :controller => 'home', :action => 'view_link'

  # See how all your routes lay out with "rake routes"
end
