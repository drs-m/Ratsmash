# encoding: utf-8
module API
    module V1
        class TeachersController < ApplicationController

            before_action :api_authentication

            def index
                teachers = Teacher.order(:id)
                teachers = JSON.pretty_generate(JSON.parse(teachers.to_json.to_s)) if params[:p]
                render json: teachers, except: [:created_at, :updated_at], status: :ok
            end

        end
    end
end
