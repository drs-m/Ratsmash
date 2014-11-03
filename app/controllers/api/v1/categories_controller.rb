# encoding: utf-8
module API
module V1
class CategoriesController < ApplicationController

    before_action :api_authentication

    def index
        categories = Category.order :id
        if params[:group_id]
            categories = categories.where group_id: params[:group_id]
        end

        if params[:p]
            render json: JSON.pretty_generate(JSON.parse(categories.to_json.to_s))
        else
            render json: categories, except: [:created_at, :updated_at], status: :ok
        end
    end

end
end
end
