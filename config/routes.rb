Rails.application.routes.draw do
  get "versions/:key" => "versions#show"
  get "comparison/:key1/:key2" => "comparison#show"

  if Rails.env.development?
    require "sidekiq/pro/web"
    mount Sidekiq::Web => "/sidekiq"
  end

  root "home#index"
  match "*missing", to: "application#not_found", via: :all
end
