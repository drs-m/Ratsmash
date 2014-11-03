# encoding: utf-8
module API
module V1
class StudentsController < ApplicationController

    before_action :api_authentication

    def index
        students = Student.order :id
        students = students.where gender: (params[:gender] == "m") if params[:gender]

        if params[:p]
            render json: JSON.pretty_generate(JSON.parse(students.to_json.to_s))
        else
            render json: students, except: [:created_at, :updated_at], status: :ok
        end
    end

end
end
end
