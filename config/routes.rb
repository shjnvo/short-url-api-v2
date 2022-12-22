Rails.application.routes.draw do
  namespace :v1 do
    post 'decode', to: 'short_urls#decode'
    post 'encode', to: 'short_urls#encode'
  end
end
