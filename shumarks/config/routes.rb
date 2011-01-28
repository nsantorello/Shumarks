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
  
  map.bookmarklet '/bm/:salt', :controller => 'bookmarklet', :action => 'remote_bookmarklet_javascript'
  
  map.signup '/signup', :controller => 'users', :action => 'signup'
  map.signup_action '/session/create', :controller => 'session', :action => 'create'
  map.login '/login', :controller => 'users', :action => 'login'                                                   
  map.logout '/logout', :controller => 'session', :action => 'destroy'
  map.access_denied '/access_denied', :controller => 'session', :action => 'access_denied'

  # Flat pages
  map.home '/', :controller => 'home', :action => 'index'
  map.about '/about', :controller => 'home', :action => 'about'
  
  # Links
  map.link_save '/links/create', :controller => 'links', :action => 'save', :conditions => {:method => :post}
  map.link_create '/links/create', :controller => 'links', :action => 'create', :conditions => {:method => :get}
  map.link '/links/:id', :controller => 'links', :action => 'view'
  
  # Comments
  map.comment_create '/comments/create', :controller => 'comments', :action => 'create', :conditions => {:method => :post}
  map.comment_show   '/comments/:link_id/', :controller => 'comments', :action => 'show', :conditions => {:method => :get}
  
  # Tutorial
  map.tutorial_start '/tutorial/start', :controller => 'tutorial', :action => 'start'
  map.tutorial_step1 '/tutorial/step1', :controller => 'tutorial', :action => 'step1'
  map.tutorial_step2 '/tutorial/step2', :controller => 'tutorial', :action => 'step2'
  map.tutorial_completed '/tutorial/completed', :controller => 'tutorial', :action => 'completed'
  map.tutorial_example '/tutorial/example', :controller => 'tutorial', :action => 'example'
  
  # Discover
  map.discover_index '/discover', :controller => 'discover', :action => 'index'
  
  # User pages
  map.edit_user '/account', :controller => 'users', :action => 'edit'
  map.remote_login '/remote-login/', :controller => 'users', :action => 'remote_get_salt'
  map.remote_list '/remote-list/', :controller => 'users', :action => 'remote_get_list'
  map.remote_create '/remote-create/', :controller => 'bookmarklet', :action => 'old_bookmarklet_landing'
  map.remote_result '/remote-result/', :controller => 'users', :action => 'remote_result'
  map.friend_finder '/friend-finder', :controller => 'users', :action => 'friend_finder'
  
  map.create_user_action '/user/create',
    :controller => 'users', 
    :action => 'create', 
    :conditions => {:method => :post}
  
  map.edit_user_action '/user/edit', 
    :controller => 'users', 
    :action => 'update', 
    :conditions => {:method => :post}
    
  map.delete_user_action '/user/delete', 
    :controller => 'users', 
    :action => 'delete' 
    
  map.show_user '/user/',
    :controller => 'users', 
    :action => 'show'
   
  map.user_links '/user/links', :controller => 'links', :action => 'index'

  
  map.delete_link '/user/links/delete/:id', :controller => 'links', :action => 'delete'
  map.link_redirect '/v/:id', :controller => 'links', :action => 'redir'
  
  map.follow '/follow/:id', :controller => 'users', :action => 'follow'
  map.unfollow '/unfollow/:id', :controller => 'users', :action => 'unfollow'
  map.follow_list '/follow-list/', :controller => 'users', :action => 'follow_list'
  map.follower_list '/follower-list/', :controller => 'users', :action => 'follower_list'
  map.search_users '/search-users/', :controller => 'users', :action => 'search'
  
  map.user_home '/home', :controller => 'users', :action => 'home'
  map.user '/:user_name', :controller => 'users', :action => 'links'

  # See how all your routes lay out with "rake routes"
end
