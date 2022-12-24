Rails.application.routes.draw do
  match ':code', to: 'v1/short_urls#redirect_link', via: :get

  namespace :v1, defaults: { format: :json } do
    match ':code', to: 'short_urls#decode', via: :get
    post 'encode', to: 'short_urls#encode'
  end
end
