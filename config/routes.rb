Rails.application.routes.draw do
  post 'tags/new'
  post 'tags/create'
  put 'tags/update'
  put 'tags/edit'
  post 'tags/destroy'
  get 'tags/index'
  get 'tags/show'
  get  'tags/sort', to: 'tags#sort_on_a_field'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'
  post 'delete', to: 'users#delete_user'
  get  'index', to: 'users#all_users'
  put  'update', to: 'users#update'
  get  'sort', to: 'users#sort_on_a_field'
  get  'filter', to: 'users#filter_on_fields'
  post  'user/tags', to: 'users#user_tags'


end
