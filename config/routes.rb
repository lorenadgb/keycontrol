Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }, :skip => :registrations
  root 'pages#index'

  resources :users
  resources :real_state_agencies, except: :destroy
  resources :keys, except: [:index, :new, :show, :edit] do
    collection do
      get  'print' => 'keychains#print', via: :get
      post 'print' => 'keychains#print', via: :post
      get  'print_keychains' => 'keychains#print_keychains', via: :get
    end
  end
  resources :addresses
  resources :people, except: [:index]
  resources :buildings, except: [:index] do
    collection do
      get 'disable/:id' => 'buildings#disable', as: 'disable'
      get 'enable/:id' => 'buildings#enable', as: 'enable'
    end
  end

  get 'update_keys' => 'buildings#update_keys', via: :get

  resources :visits, except: [:index]
  resources :settings

  get 'set_status_to_available' => 'keys#set_status_to_available', via: :get
  get 'update_keys'      => 'visits#update_keys', via: :get
  get 'update_buildings' => 'visits#update_buildings', via: :get
  get 'update_owner'    => 'visits#update_owner', via: :get

  get 'index' => 'pages#index', via: :get, as: 'pages'

  get  'generate_building_report' => 'building_reports#generate', via: :get
  post 'generate_building_report' => 'building_reports#generate', via: :post

  get  'generate_visit_report' => 'visit_reports#generate', via: :get
  post 'generate_visit_report' => 'visit_reports#generate', via: :post

  get  'report_key_report' => 'key_reports#report', via: :get
  get  'not_in_use' => 'key_reports#not_in_use', via: :get
  get  'print_not_in_use' => 'key_reports#print_not_in_use', via: :get
end
