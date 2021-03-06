Mypeeps::Application.routes.draw do

	root to: "static_pages#home"
	get "updates/updates"
	get "updates/posts"
	get "updates/comments"
	
	resources :stream, only: :comments do
		get 'comments', on: :member
	end
	resources :members do
		get 'crop', on: :member
		get 'new_post', on: :member
	end
	resources :sessions, only: [ :new, :create, :destroy]
	resources :auth_api, only: [ :create, :destroy]
	resources :relationships, only: [ :create, :destroy]
	resources :spouse_relationships, only: [ :create, :destroy]
	resources :tree, only: [ :show, :edit, :update]
	resources :password_resets, only: [ :new, :create, :edit, :update] do
		member do
			get :change_password
			patch :update_password
		end
	end
	resources :comments, only: [ :create, :destroy]
	resources :posts, only: [ :show, :create, :edit, :update, :destroy] do
		member { get :partial }
	end
	
	get '/signup', to: 'members#new'
	get '/signin', to: 'sessions#new'
	delete '/signout', to: 'sessions#destroy'

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
