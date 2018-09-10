Rails.application.routes.draw do
  get "stats/:id" => "stats#show"
  root "home#index"
end
