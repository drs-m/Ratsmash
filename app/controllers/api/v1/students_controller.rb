# encoding: utf-8
module API
module V1
class StudentsController < ApplicationController

    def index
        students = Student.all
        students = students.where gender: (params[:gender] == "m") if params[:gender]
        render json: students, only: [:name], status: :ok
    end

end
end
end
