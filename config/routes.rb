Rails.application.routes.draw do
  get "versions/:key" => "versions#show"
  get "comparison/:key1/:key2" => "comparison#show"
  root "home#index"
  match "*missing", to: "application#not_found", via: :all
end
