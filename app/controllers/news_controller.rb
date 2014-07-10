class NewsController < ApplicationController

    before_action -> { check_session redirect: true }

    def index
        @news = News.all.order(:updated_at).reverse
    end

    def show
        if News.find_by_id params[:id]
            @news = News.find_by_id params[:id]
            @news_content = @news.content.split("[p_end]")
        else 
            redirect_to news_index_path
        end
    end

    def new
        if !@current_user.admin_permissions
            redirect_to :back
        end
    end

    def create
        if @current_user.admin_permissions
            if !params[:author].blank? && !params[:subject].blank? && !params[:content].blank?
                News.create :subject => params[:subject], :author => params[:author], :content => params[:content]
            end
        end
        redirect_to news_index_path
    end

    def edit
        if @current_user.admin_permissions
            if News.find_by_id params[:id]
                @news = News.find_by_id params[:id]
            else 
                redirect_to news_index_path
            end
        else 
            redirect_to news_index_path
        end
    end

    def update
        if @current_user.admin_permissions
            if News.find_by_id params[:news_id]
                news = News.find_by_id params[:id]
                news.update_attributes :subject => params[:subject], :author => params[:author], :content => params[:content]
            end
        end
        redirect_to news_index_path
    end

    def destroy
        if @current_user.admin_permissions
            if News.find_by_id params[:id]
                news = News.find_by_id params[:id]
                news.delete
            end
        end
        redirect_to news_index_path
    end

end