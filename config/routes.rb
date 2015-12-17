Rails.application.routes.draw do

  root 'projects#root'
  # for normal hosting
  # get '/uploads/comment/attachments/:comment_id/:file_name.:format' => 'downloads#download'
  # for heroku
  get '/tmp/uploads/comment/attachments/:comment_id/:file_name.:format' => 'downloads#download'

  mount_devise_token_auth_for 'User', at: 'auth'

  resources :projects, only: [:index, :create, :destroy, :update] do
    resources :tasks, only: [:create, :destroy, :update] do
      resources :comments, only: [:index, :create, :destroy]
    end
  end

end
