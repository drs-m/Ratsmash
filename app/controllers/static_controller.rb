# encoding: utf-8

class StaticController < ApplicationController

    before_action -> { check_session redirect: false }

    # controller für statische seiten. methoden fehlen meistens da die seiten eben statisch sind und daher nur durch die view funktionieren

    def update_head_info
        head_info_path = Rails.root + "head_info.yml"
        if params[:token] == ENV["HEAD_UPDATE_TOKEN"]
            head_info = { sha: params[:sha], user_mail: params[:user_mail] }
            File.open(head_info_path, "w") { |f| f.write head_info.to_yaml }
            render text: "Success: " + head_info.to_s and return
        else
            render text: "no file" and return unless File.exists?(head_info_path)
            head_info = YAML.load_file(head_info_path)
            render text: head_info.to_s if head_info.present?
        end
    end

end
