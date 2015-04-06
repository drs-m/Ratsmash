class ClassTripsController < ApplicationController

  before_action :set_class_trip, only: [:show, :edit, :update, :destroy]
  before_action -> { check_session redirect: true, restricted_methods: [:index, :edit, :update, :destroy] }

  # GET /class_trips
  # GET /class_trips.json
  def index
    @class_trips = ClassTrip.all
  end

  # GET /class_trips/1
  # GET /class_trips/1.json
  def show
    unless @class_trip.sender == @current_user or @current_user.has_permission("course_trips.shoattr_writer :attr_names")
      flash[:error] = "Du kannst dir diesen Bericht nicht angucken"
      redirect_to :home
    end
  end

  # GET /class_trips/new
  def new
    @class_trip = ClassTrip.new
  end

  # GET /class_trips/1/edit
  def edit
  end

  # POST /class_trips
  # POST /class_trips.json
  def create
    @class_trip = ClassTrip.new(class_trip_params.merge({sender_id: @current_user.id}))

    respond_to do |format|
      if @class_trip.save
        format.html { redirect_to @class_trip, notice: 'Der Kursfahrtbericht wurde gespeichert' }
        format.json { render action: 'show', status: :created, location: @class_trip }
      else
        format.html { render action: 'new' }
        format.json { render json: @class_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /class_trips/1
  # PATCH/PUT /class_trips/1.json
  def update
    respond_to do |format|
      if @class_trip.update(class_trip_params)
        format.html { redirect_to @class_trip, notice: 'Der Kursfahrtbericht wurde gespeichert' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @class_trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /class_trips/1
  # DELETE /class_trips/1.json
  def destroy
    @class_trip.destroy
    respond_to do |format|
      format.html { redirect_to class_trips_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_class_trip
      @class_trip = ClassTrip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def class_trip_params
      params.require(:class_trip).permit(:course, :text)
    end
end
