class TicketsController < ApplicationController

  before_action -> { check_session redirect: true, restricted_methods: [:destroy] }
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  # GET /tickets
  # GET /tickets.json
  def index
    @my_order = @current_user.ticket
    @all_orders = Ticket.all if @current_user.has_permission("tickets.show_all")
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
    unless @ticket.student == @current_user or @current_user.has_permission("tickets.edit_all")
      flash[:error] = "Du hast keine Berechtigung dafür"
      redirect_to :tickets
    end
  end

  # POST /tickets
  # POST /tickets.json
  def create
    if @current_user.ticket.present?
        flash[:error] = "Du kannst keinen weiteren Eintrag erstellen. Bitte bearbeite den ersten stattdessen."
        redirect_to :tickets and return
    end

    @ticket = Ticket.new(ticket_params.merge({student_id: @current_user.id}))

    if ticket_params[:type_1] == "0" and ticket_params[:type_2] == "0"
      redirect_to :tickets
    elsif @ticket.save
      flash[:notice] = "Eintrag gespeichert"
      redirect_to :tickets
    else
      render action: 'edit'
    end
  end

  # PATCH/PUT /tickets/1
  def update
    unless @ticket.student == @current_user or @current_user.has_permission("tickets.edit_all")
        flash[:error] = "Du hast keine Berechtigung dafür"
      redirect_to :tickets and return
    end

    if ticket_params[:type_1] == "0" and ticket_params[:type_2] == "0"
      @ticket.destroy
      flash[:error] = "Eintrag gelöscht"
      redirect_to :tickets and return
    end

    if @ticket.update(ticket_params)
      flash[:notice] = "Eintrag gespeichert"
      redirect_to :tickets
    else
      flash[:error] = @ticket.errors.messages.values.join(", ")
      puts @ticket.errors.messages.values.join(", ")
      render action: 'edit', error: @ticket.errors.messages.values.join(", ")
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    redirect_to tickets_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ticket_params
    params.require(:ticket).permit(:type_1, :type_2)
  end

end
