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

		if Student.find_by_name @description.described_name.to_s.strip.split.map(&:capitalize).join(' ')
			described_id = Student.find_by_name(@description.described_name.to_s.strip.split.map(&:capitalize).join(' ')).id
			if Description.where(:author_id => @current_user.id, :described_id => described_id).count <1
				if @description.save
					redirect_to :descriptions, flash: {notice: "Beschreibung wurde erfolgreich erstellt"}
				else
					flash[:error] = 'Beschreibung konnte nicht erstellt werden'
					render action: 'new'
				end
			else
				flash[:error] = 'Für diesen Schüler hast du bereits eine Beschreibung geschrieben'
				redirect_to :descriptions
			end
		else
			flash[:error] = 'Der beschriebene Schüler konnte nicht gefunden werden'
			redirect_to :descriptions
		end
	end

	def edit
		if @description.author != @current_user
			redirect_to :descriptions
		end
	end

	def update
		if @description.update(description_params)
        	redirect_to descriptions_path, flash: {notice: "Beschreibung wurde erfolgreich bearbeitet"}
      	else
      		flash[:error] = 'Beschreibung konnte nicht bearbeitet werden'
       		render action: 'edit'
      	end
	end

	def destroy
		@description.destroy
		redirect_to descriptions_path, flash: {notice: "Beschreibung wurde erfolgreich geloescht"}
	end

	def categorize
		if @description and params[:state].present?
			case params[:state]
				when "accept"
					status = 1
				when "not_sure"
					status = 0
				when "reject"
					status = -1
			end
			@description.described_name = Student.find_by_id(@description.described_id).name
			if @description.update status: status
				redirect_to :descriptions, flash: {notice: "Beschreibung wurde erfolgreich neu eingeordnet"}
			else
				flash[:error] = "Die Beschreibung konnte nicht eingeordnet werden"
				redirect_to :descriptions
			end
		end
	end

	private
		# Never trust parameters from the scary internet, only allow the white list through.
		def description_params
		  params.require(:description).permit(:described_name, :content, :interests, :hobbies, :additional_authors)
		end

		def set_description
			@description = Description.find(params[:id])
		end

end
