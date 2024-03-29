# encoding: utf-8
class CategoriesController < ApplicationController

  before_action -> { check_session redirect: true, restricted_methods: [:all] }
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.order :name

    respond_to do |format|
      format.html
      format.json { render(json: JSON.pretty_generate(JSON.parse(@categories.to_json(except: [:id, :created_at, :updated_at])))) }
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to categories_path, flash: {notice: "Kategorie wurde erfolgreich hinzugefuegt"} }
      else
        flash[:error] = 'Kategorie konnte nicht angelegt werden'
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /categories/1
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to categories_path, flash: {notice: "Kategorie wurde erfolgreich bearbeitet"} }
      else
        flash[:error] = 'Kategorie konnte nicht bearbeitet werden'
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_path, flash: {notice: "Kategorie wurde erfolgreich geloescht"} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :group_id, :closed)
    end

end
