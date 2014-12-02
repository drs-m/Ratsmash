# encoding: utf-8
class QuotesController < ApplicationController

  before_action -> { check_session redirect: true }, only: [:create, :new] # nicht-admins können nur zitate erstellen
  before_action -> { check_session redirect: true, destination: :new_quote, admin_permissions: true }, except: [:create, :new]
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.order(:teacher)
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = Quote.new(quote_params)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to new_quote_path, notice: 'Das Zitat wurde erfolgreich gespeichert. Danke!' }
      else
        format.html { render action: 'new', error: 'Zitat konnte nicht gespeichert werden' }
      end
    end
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Zitat wurde erfolgreich bearbeitet!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', error: 'Zitat konnte nicht bearbeitet werden' }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.require(:quote).permit(:sender, :text, :teacher)
    end
end
