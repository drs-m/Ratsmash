Ratsmash::Application.routes.draw do

    # API Routing
    namespace :api, path: "/", constraints: { subdomain: "api" } do
        namespace :v1 do
            resources :students, only: [:index]
            resources :votes, only: [:index]
            resources :categories, only: [:index]
        end
    end

    # POLL ROUTES
    resources :poll
    post "/vote_poll", to: "poll#vote_poll"
    post "/remove_vote_poll", to: "poll#remove_vote_poll"
    post "/add_poll_vote_options", to: "poll#add_poll_vote_options"

    get 'page_stats/index'
    post 'page_stats/index'

    get 'impress/index'

    # voting#home als startseite
    root "voting#home", as: :home

    post "get_newsticker_news", to: "voting#get_newsticker_news"

    resources :students
    resources :teachers
    resources :categories
    resources :news
    resources :quotes
    resources :descriptions do
        member do
            get 'categorize'
        end
    end

    resources :release_state, :only => "index"

    #PROJECT GOES LIVE
    post "send_mails_to_students", to: "release_state#send_mails_to_students"
    post "get_mail_status", to: "release_state#get_mail_status"
    get "launch_reset", to: "release_state#reset", as: :launch_reset

    #DESCRIPTION ROUTES
    #get "categorize_description/:id/:state", to: "descriptions#categorize", as: :categorize_description

    #CONTACT ROUTES
    get "/contacts", to: "contacts#index", as: :contacts
    get "/send_contact_form", to: "contacts#send_contact_form", as: :send_contact_form
    post "/send_contact_form", to: "contacts#send_contact_form"

    # account activation / password reset
    get "reset_password", to: "session#reset_password", as: :reset_password
    post "reset_password", to: "session#reset_password"
    get "change_password/(:token)", to: "students#change_password", as: :change_password
    post "change_password/(:token)", to: "students#change_password"

    # SESSION ROUTES
    get "login", to: "session#login", as: :login
    post "login", to: "session#login"
    get "logout", to: "session#logout", as: :logout

    # VOTING ROUTES
    get "vote", to: "voting#list", as: :category_list
    get "vote/results", to: "voting#results", as: :results
    post "vote/delete_vote", to: "voting#delete_vote", as: :delete_vote

    get "vote/autocomplete", to: "voting#autocomplete"

    # only accept category-ids from 0-99
    get "vote/:category_id(-(:category_name))", to: "voting#choose", as: :give_vote, category_id: /[0-9]{1,2}/
    post "vote/:category_id", to: "voting#commit", category_id: /[0-9]{1,2}/

    # SETTINGS ROUTES
    get "settings", to: "settings#menu", as: :settings

    # STATIC PAGES
    static_pages = [:imprint, :privacy, :update_head_info]
    static_pages.each { |static_page| get static_page.to_s, to: "static#" + static_page.to_s, as: ("static_" + static_page.to_s).intern }

end
