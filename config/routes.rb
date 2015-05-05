Ratsmash::Application.routes.draw do

    # API Routing
    # namespace :api, path: "/", constraints: { subdomain: "api" } do
    #     namespace :v1 do
    #         resources :students, only: [:index]
    #         resources :categories, only: [:index]
    #         resources :teachers, only: [:index]
    #     end
    # end

    # POLL ROUTES
    resources :polls, except: [:edit, :update]
    get "polls/vote/:poll_id", to: "polls#vote", as: :vote_poll
    post "polls/vote/:poll_id", to: "polls#vote", as: :commit_poll_vote
    get "polls/unvote/:poll_id", to: "polls#unvote", as: :unvote_poll

    get "/open_poll/:poll_id", to: "polls#open_poll", as: :open_poll
    get "/close_poll/:poll_id", to: "polls#close_poll", as: :close_poll

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
    resources :tickets, except: :show
    resources :class_trips
    resources :child_pics
    match "/uploads/child_pics/:id/:basename.:extension", :controller => "child_pics", :action => "download", via: :get


    get 'all-descriptions', to: 'descriptions#list_all'
    get 'all-quotes', to: 'quotes#list_all'

    # resources :release_state, :only => "index"

    #PROJECT GOES LIVE
    # post "send_mails_to_students", to: "release_state#send_mails_to_students"
    # post "get_mail_status", to: "release_state#get_mail_status"
    # get "launch_reset", to: "release_state#reset", as: :launch_reset

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
    get "vote/:category_id(-(:category_name))", to: "voting#choose", as: :give_vote, category_id: /[0-9]{1,3}/
    post "vote/:category_id", to: "voting#commit", category_id: /[0-9]{1,3}/

    # SETTINGS ROUTES
    get "settings", to: "settings#menu", as: :settings

    # STATIC PAGES
    static_pages = [:imprint, :privacy, :update_head_info]
    static_pages.each { |static_page| get static_page.to_s, to: "static#" + static_page.to_s, as: ("static_" + static_page.to_s).intern }

    # custom error pages

    get 'errors/file_not_found'
    get 'errors/unprocessable'
    get 'errors/internal_server_error'

    match '/404', to: 'errors#file_not_found', via: :all
    match '/422', to: 'errors#unprocessable', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all

end
