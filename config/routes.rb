Ratsmash::Application.routes.draw do

  # voting#home als startseite
  root "voting#home", as: "home"

  # STUDENT AND TEACHER ROUTES
  resources :students
  resources :teachers 
  # account activation / password reset 
  get "reset_password", to: "student#reset_password", as: :reset_password 
  post "reset_password", to: "student#reset_password"

  # SESSION ROUTES
  get "login", to: "session#login", as: "login"
  post "login", to: "session#login"
  get "logout", to: "session#logout", as: "logout"
  # temp for dev!
  get "session/instantlogin"
  
  # voting ROUTES
  get "vote", to: "voting#list", as: :category_list
  get "vote/edit"
  post "vote/edit", to: "voting#update"

  # only accept category-ids from 0-99
  get "vote/:category_id(-(:category_name))", to: "voting#choose", as: :give_vote, category_id: /[0-9]{1,2}/
  post "vote/:category_id(-(:category_name))", to: "voting#voting", category_id: /[0-9]{1,2}/

  # SETTINGS ROUTES
  get "settings", to: "settings#menu", as: "settings"

end
