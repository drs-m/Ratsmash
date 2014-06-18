class DescriptionController < ApplicationController
	before_action -> { check_session redirect: true }

	def index

	end

	def new 

	end

	def create
		if params[:name] && params[:description] && params[:interests] && params[:hobbies]
			from_id = @current_user.id

			if Student.find_by_name params[:name]
				for_id = Student.find_by_name(params[:name]).id
				Description.create :for_id => for_id, :from_id => from_id, :content => params[:description], :status => -1, :additional_authors => params[:additional_authors], :interests => params[:interests], :hobbies => params[:hobbies]
			end
		end
		redirect_to description_index_path
	end


	def edit

	end

	def update

	end

	def destroy

	end

end
