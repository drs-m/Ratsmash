# encoding: utf-8
class TeachersController < ApplicationController

  # check for current admin-session
  before_action -> { check_session redirect: true, restricted_methods: [:all] }
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  # GET /teachers
  # GET /teachers.json
  def index
    @teachers = Teacher.order :name
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers
  # POST /teachers.json
  def create
    @teacher = Teacher.new(processed_params)

    respond_to do |format|
      if @teacher.save
        format.html { redirect_to @teacher, flash: {notice: "Lehrer wurde erfolgreich erstellt"} }
        format.json { render action: 'show', status: :created, location: @teacher }
      else
        flash[:error] = 'Lehrer konnte nicht angelegt werden'
        format.html { render action: 'new' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1
  # PATCH/PUT /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(processed_params)
        format.html { redirect_to @teacher, flash: {notice: "Lehrer wurde erfolgreich bearbeitet"} }
        format.json { head :no_content }
      else
        flash[:error] = 'Lehrer konnte nicht bearbeitet werden'
        format.html { render action: 'edit' }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to teachers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find(params[:id])
    end

    def processed_params
      params_copy = teacher_params
      params_copy[:gender] = params_copy[:gender] == "m" ? true : false
      return params_copy
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:name, :gender, :closed)
    end
end
