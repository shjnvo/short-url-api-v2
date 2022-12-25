Rails.application.routes.draw do
  namespace :v1, defaults: { format: :json } do
    match ':code', to: 'short_urls#decode', via: :get
    post 'encode', to: 'short_urls#encode'
  end
end
