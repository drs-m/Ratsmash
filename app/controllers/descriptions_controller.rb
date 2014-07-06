# encoding: utf-8
class DescriptionsController < ApplicationController
	before_action -> { check_session redirect: true, admin_permissions: true }, only: [:show]
	before_action -> { check_session redirect: true }, except: [:show]

	def index
		@own_descriptions = @current_user.descriptions
		@written_descriptions = @current_user.written_descriptions
		#@unaccepted_descriptions_for_me = Description.where(:for_id => @current_user.id, :status => 0).order(:updated_at).reverse
		#@rejected_descriptions_for_me = Description.where(:for_id => @current_user.id, :status => -1).order(:updated_at).reverse
		#@allowed_description_for_me = Description.where(:for_id => @current_user.id, :status => 1).first
		#@written_descriptions = Description.where(:from_id => @current_user.id).order(:updated_at).reverse
	end

	def new 

	end

	def create
		@description = Description.new(description_params)
		if !params[:name].blank? && !params[:description].blank? && !params[:interests].blank? && !params[:hobbies].blank?
			from_id = @current_user.id

			if Student.find_by_name params[:name]
				for_id = Student.find_by_name(params[:name]).id
				if for_id != from_id
					Description.create :for_id => for_id, :from_id => from_id, :content => params[:description], :status => 0, :additional_authors => params[:additional_authors], :interests => params[:interests], :hobbies => params[:hobbies]
				end
			end
		end
		redirect_to descriptions_path
	end

	def show 
		if Description.find_by_id params[:id]
			@description = Description.find_by_id params[:id]
		else
			redirect_to descriptions_path
		end
	end

	def edit
		@description = Description.find_by_id params[:id]
	end

	def update
		if Description.find_by_id params[:description_id]
			if Student.find_by_id params[:for_id]
				if !params[:name].blank? && !params[:description].blank? && !params[:interests].blank? && !params[:hobbies].blank?
					if params[:description] && params[:interests] && params[:hobbies] && params[:additional_authors]
						Description.find_by_id(params[:description_id]).update_attributes :content => params[:description], :interests => params[:interests], :hobbies => params[:hobbies], :additional_authors => params[:additional_authors], :status => 0
					end
				end
			end
		end
		redirect_to descriptions_path
	end

	def destroy
		description = Description.find_by_id params[:id]
		description.delete
		redirect_to descriptions_path
	end

	def reject_description
		if Description.find_by_id params[:id]
			Description.find_by_id(params[:id]).update_attributes :status => -1
		end

		redirect_to descriptions_path
	end

	def allow_description
		if Description.find_by_id params[:id]
			if Description.where(:for_id => @current_user.id, :status => 1).count > 0
				Description.where(:for_id => @current_user.id, :status => 1).first.update_attributes :status => 0
				Description.find_by_id(params[:id]).update_attributes :status => 1
			else
				Description.find_by_id(params[:id]).update_attributes :status => 1
			end
		end

		redirect_to descriptions_path
	end

	def unordered_description
		if Description.find_by_id params[:id]
			Description.find_by_id(params[:id]).update_attributes :status => 0
		end

		redirect_to descriptions_path
	end

	private
	    # Never trust parameters from the scary internet, only allow the white list through.
	    def category_params
	      params.require(:description).permit(:content, :interests, :hobbies, :additional_authors)
	    end

end
