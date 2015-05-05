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
      redirect_to :tickets, notice: "Du hast keine Berechtigung dafür"
    end
  end

  # POST /tickets
  # POST /tickets.json
  def create
    redirect_to :tickets and return if @current_user.ticket.present?

    @ticket = Ticket.new(ticket_params.merge({student_id: @current_user.id}))

    if ticket_params[:amount] == "0"
      redirect_to :tickets
    elsif @ticket.save
      redirect_to :tickets, notice: 'Eintrag gespeichert'
    else
      render action: 'edit'
    end
  end

  # PATCH/PUT /tickets/1
  def update
    unless @ticket.student == @current_user or @current_user.has_permission("tickets.edit_all")
      redirect_to :tickets, notice: "Du hast keine Berechtigung dafür" and return
    end

    if ticket_params[:amount] == "0"
      @ticket.destroy
      flash[:error] = "Eintrag gelöscht"
      redirect_to :tickets and return
    end

    if @ticket.update(ticket_params.merge({student_id: @current_user.id}))
      redirect_to :tickets, notice: 'Eintrag gespeichert'
    else
      flash[:error] = @ticket.errors.messages.values.join(", ")
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
    params.require(:ticket).permit(:amount)
  end

end
