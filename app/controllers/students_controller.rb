# encoding: utf-8
class StudentsController < ApplicationController

  # check for current admin-session
  before_action -> { check_session redirect: true, restricted_methods: [:all] }, except: [:change_password]
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  # GET /students
  # GET /students.json
  def index
    # schüler wurden nach aufsteigendem nachnamen gespeichert
    @students = Student.order :id
    respond_to do |format|
      format.html
      # json ausgabe für die speicherung in einer text datei, sodass man die schüler bei db-absturz aus der json einlesen kann
      format.json { render json: JSON.pretty_generate(JSON.parse(Student.all.to_json(except: [:id, :created_at, :updated_at]))) }
    end
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(processed_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, flash: {notice: "Schueler wurde erfolgreich erstellt"} }
        format.json { render action: 'show', status: :created, location: @student }
      else
        flash[:error] = 'Schueler konnte nicht angelegt werden'
        format.html { render action: 'new' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(processed_params)
        format.html { redirect_to @student, flash: {notice: "Schueler wurde erfolgreich bearbeitet"} }
        format.json { head :no_content }
      else
        flash[:error] = 'Schueler konnte nicht bearbeitet werden'
        format.html { render action: 'edit' }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url }
      format.json { head :no_content }
    end
  end

  def printable
    @students = Student.all.sort_by { |s| s.name.split(" ")[1] }
    render layout: "plain"
  end

  # NOT VERY DRY! - TODO
  def change_password
    @errors = []
    if params[:token]
      # password-reset
      student = Student.find_by password_reset_token: params[:token]
      @errors << "Dieser Link ist ungueltig" and @fatal = true and return unless student
      @name = student.name
      # @errors << "Dieser Link ist abgelaufen" and @fatal = true if student.password_reset_sent_at < 2.hours.ago
      if params[:new_password]
        if params[:password_confirmation].present? && params[:new_password] == params[:password_confirmation]
          student.password = params[:new_password]
          student.password_reset_token = nil
          student.password_reset_sent_at = nil
          student.save
          redirect_to :login, flash: {notice: "Dein Passwort wurde erfolgreich geaendert"}
        else
          @errors << "Die Passwoerter stimmen nicht ueberein!"
        end
      end
    else
      check_session redirect: true
      # password-änderung
      if params[:new_password]
        @errors << "Das alte Passwort ist nicht richtig" and return unless @current_user.authenticate params[:old_password]
        if params[:password_confirmation].present? && params[:new_password] == params[:password_confirmation]
            @current_user.password = params[:new_password]
            @current_user.password_confirmation = params[:new_password]
            @current_user.save
            redirect_to :home, flash: {notice: "Dein Passwort wurde erfolgreich geaendert"}
        else
          @errors << "Die Passwoerter stimmen nicht ueberein!"
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    def processed_params
      params_copy = student_params
      params_copy[:gender] = params_copy[:gender] == "m" ? true : false
      params_copy[:password_confirmation] = params_copy[:password]
      return params_copy
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name, :gender, :mail_address, :password, :closed, :admin_permissions)
    end
end
