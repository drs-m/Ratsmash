# encoding: utf-8

class StaticController < ApplicationController

    before_action -> { check_session redirect: false }

    # controller für statische seiten. methoden fehlen meistens da die seiten eben statisch sind und daher nur durch die view funktionieren

    def update_head_information
        if params[:token] == "t12y8"
            head_info_path = Rails.root + "head_info.yml"
            head_info = { sha: params[:sha], user_mail: params[:user_mail] }
            File.open(head_info_path, "w") { |f| f.write head_info.to_yaml }
            render text: "Success: " + head_info.to_s and return
        else
            render text: YAML.load_file(head_info_path).to_s
        end
    end

end
