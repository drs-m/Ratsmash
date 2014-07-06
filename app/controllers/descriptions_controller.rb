# encoding: utf-8
class DescriptionsController < ApplicationController

	before_action -> { check_session redirect: true, admin_permissions: true }, only: [:show]
	before_action -> { check_session redirect: true }, except: [:show]
	before_action :set_description, only: [:show, :edit, :update, :destroy, :categorize]

	def index
		@own_descriptions = @current_user.descriptions.order(status: :desc)
		@written_descriptions = @current_user.written_descriptions
	end

	def new 
		@description = Description.new
	end

	def create
		@description = Description.new(description_params)
		@description.author_id = @current_user.id
		#render text: @description.to_yaml and return

		if @description.save
			redirect_to :descriptions, notice: 'Die Kategorie wurde erfolgreich hinzugefügt.'
		else
			render action: 'new'
		end
	end

	def edit
		if @description.author != @current_user
			redirect_to :descriptions
		end
	end

	def update
		if @description.update(description_params)
        	redirect_to descriptions_path, notice: 'Der Eintrag wurde erfolgreich bearbeitet.'
      	else
       		render action: 'edit'
      	end
	end

	def destroy
		@description.destroy
		redirect_to descriptions_path
	end

	def categorize
		if @description and params[:state].present?
			case params[:state]
				when "accept"
					status = 1
				when "reject"
					status = -1
			end

			if @description.update status: status
				redirect_to :descriptions
			else
				recirect_to :descriptions, notice: "Die Beschreibung konnte nicht eingeordnet werden"
			end
		end
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
		def description_params
		  params.require(:description).permit(:described_id, :content, :interests, :hobbies, :additional_authors)
		end

		def set_description
			@description = Description.find(params[:id])
		end

end
