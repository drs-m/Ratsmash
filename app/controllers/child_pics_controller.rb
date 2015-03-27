class ChildPicsController < ApplicationController

  before_action -> { check_session redirect: true, restricted_methods: [:index, :show, :edit, :update, :destroy, :download] }
  before_action :set_child_pic, only: [:show, :edit, :update, :destroy, :download]

  # GET /child_pics
  # GET /child_pics.json
  def index
    @child_pics = ChildPic.all
  end

  # GET /child_pics/1
  # GET /child_pics/1.json
  def show
  end

  # GET /child_pics/new
  def new
    @child_pic = ChildPic.new
  end

  # GET /child_pics/1/edit
  def edit
  end

  # POST /child_pics
  # POST /child_pics.json
  def create
    @child_pic = ChildPic.new(child_pic_params.merge({sender_id: @current_user.id}))

    respond_to do |format|
      if @child_pic.save
        format.html { redirect_to :home, notice: 'Das Foto wurde gespeichert' }
        format.json { render action: 'show', status: :created, location: @child_pic }
      else
        format.html { render action: 'new' }
        format.json { render json: @child_pic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /child_pics/1
  # PATCH/PUT /child_pics/1.json
  def update
    respond_to do |format|
      if @child_pic.update(child_pic_params)
        format.html { redirect_to @child_pic, notice: 'Child pic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @child_pic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /child_pics/1
  # DELETE /child_pics/1.json
  def destroy
    @child_pic.destroy
    respond_to do |format|
      format.html { redirect_to child_pics_url }
      format.json { head :no_content }
    end
  end

  def download
    send_file @child_pic.image.url, x_sendfile: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child_pic
      @child_pic = ChildPic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_pic_params
      params.require(:child_pic).permit(:image)
    end
end
