Rails.application.routes.draw do
	mount ActionCable.server => '/cable'
	# match "/cable", to: ActionCable.server, via: [:get, :post]

	root 'admins#index'
	
  devise_for :admin_users
  resources :admins do
  	get 'chatroom', on: :member
  	get 'site', on: :member
  	delete 'delete_site', on: :member
  end
  
  resources :stores, only: [:show, :edit, :update] do
  	collection do
	  	get 'sign_in'
	  	post 'auth'
	  	post 'userout'

	  	get 'htmltag'
	  end
	  member do
	  	get 'message'
	  	post 'send_msg'
	  	post 'set_item'

	  	delete 'delete_item'
	  	post 'delete_user'

	  	get 'stuff'
	  	patch 'add_stuff'
	  	delete 'delete_stuff'
	  	delete 'logout'
	  end
  end
end
