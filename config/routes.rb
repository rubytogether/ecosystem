Rails.application.routes.draw do
  get "versions/:key" => "versions#show"
  get "comparison/:key1/:key2" => "comparison#show"
  root "home#index"
end
