Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :regions do
  	 get 'add_record_for', on: :member
  end

  resources :records do
  	collection do
  		get 'push_diff'
  		get 'push_all'
  		get 'stash'
  	end
  end

  root 'records#index'
end
