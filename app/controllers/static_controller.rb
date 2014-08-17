# encoding: utf-8
class StaticController < ApplicationController

    before_action -> { check_session redirect: false }

    # controller für statische seiten. methoden fehlen meistens da die seiten eben statisch sind und daher nur durch die view funktionieren

    def set_head_hash
        if params[:token] == "f87sgzvs7zgth3wgiwgwg53894gb52olb"
            ENV['HEAD_HASH'] = params[:new_hash]
            puts "NEW HASH: " + params[:new_hash]
            render text: "Success: " + params[:new_hash]
        end
    end

end
