MuicForum::Application.routes.draw do

  	resources :boards do
		resources :topics
  	end

  	resources :topics do
  		resources :comments
  	end  	

	resources :users
	resources :sessions, only: [:new, :create, :destroy]
	root  'boards#index'
	
	match '/signup',  to: 'users#new',            via: 'get'
    match '/signin',  to: 'sessions#new',         via: 'get'
    match '/signout', to: 'sessions#destroy',     via: 'delete'
	match '/help',    to: 'static_pages#help',    via: 'get'
	match '/tagcloud', to: 'static_pages#tagcloud', via: 'get'
	match '/about',   to: 'static_pages#about',   via: 'get'
	match '/contact', to: 'static_pages#contact', via: 'get'
	match '/tags/:tag', to: 'topics#index', as: :tag, via: 'get'
	match '/search', to: 'topics#search', via: 'get'
	match '/topics/:id/like', to: 'topics#like', via: 'post'
	match '/topics/:id/unlike', to: 'topics#unlike', via: 'post'
	match '/like',	to: 'static_pages#like', 	via: 'get'
	match '/boardpanel', to:'boards#boardpanel', via: 'get'
	match '/users/:id/admin', to: 'users#admin', via: 'post'
	match '/usersearch', to: 'users#usersearch', via:'get'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
