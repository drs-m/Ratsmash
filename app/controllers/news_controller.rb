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
            flash[:error] = "Fehler: Newsbericht koennte nicht gefunden werden. Bitte versuche es spaeter erneut!"
            redirect_to news_index_path
        end
    end

    def new
        if !@current_user.admin_permissions
            flash[:error] = "Du hast keine Administratorenrechte fuer das Erstellen neuer News!"
            redirect_to :back
        end
    end

    def create
        if @current_user.admin_permissions
            if !params[:author].blank? && !params[:subject].blank? && !params[:content].blank?
                News.create :subject => params[:subject], :author => params[:author], :content => params[:content]
                redirect_to news_index_path, flash: {notice: "News wurden erfolgreich veroeffentlicht"}
            else
                flash[:error] = "Bitte alle Felder ausfuellen zum Erstellen von neuen News!"
                redirect_to news_index_path
            end
        else
            flash[:error] = "Du hast keine Administratorenrechte fuer das Erstellen neuer News!"
            redirect_to news_index_path
        end
    end

    def edit
        if @current_user.admin_permissions
            if News.find_by_id params[:id]
                @news = News.find_by_id params[:id]
            else 
                flash[:error] = "Fehler: Newsbericht koennte nicht gefunden werden. Bitte versuche es spaeter erneut!"
                redirect_to news_index_path
            end
        else 
            flash[:error] = "Du hast keine Administratorenrechte fuer das Erstellen neuer News!"
            redirect_to news_index_path
        end
    end

    def update
        if @current_user.admin_permissions
            if News.find_by_id params[:news_id]
                news = News.find_by_id params[:id]
                if !params[:author].blank? && !params[:subject].blank? && !params[:content].blank?
                    news.update_attributes :subject => params[:subject], :author => params[:author], :content => params[:content]
                    redirect_to news_index_path, flash: {notice: "News wurden erfolgreich bearbeitet"}
                else
                    flash[:error] = "Bitte alle Felder ausfuellen zum bearbeiten von neuen News!"
                    redirect_to news_index_path
                end
            else 
                flash[:error] = "Fehler: Newsbericht koennte nicht gefunden werden. Bitte versuche es spaeter erneut!"
                redirect_to news_index_path
            end
        else
            flash[:error] = "Du hast keine Administratorenrechte fuer das Erstellen neuer News!"
            redirect_to news_index_path
        end
    end

    def destroy
        if @current_user.admin_permissions
            if News.find_by_id params[:id]
                news = News.find_by_id params[:id]
                news.delete
                redirect_to news_index_path, flash: {notice: "News wurden erfolgreich geloescht"}
            else
                flash[:error] = "Fehler: Newsbericht koennte nicht gefunden werden. Bitte versuche es spaeter erneut!"
                redirect_to news_index_path
            end
        end
    end

end