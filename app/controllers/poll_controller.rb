class PollController < ApplicationController

	def index
 		polls_already_voted_for_id = PollVote.where(:student_id => @current_user.id).pluck(:poll_id)
 		@polls_already_voted_for = []
 		polls_already_voted_for_id.each do |id|
 			@polls_already_voted_for << Poll.where(:id => id).first
 		end

 		polls_not_voted_for_id = []
 		Poll.all.each do |poll|
 			if !poll.id.in? polls_already_voted_for_id
 				polls_not_voted_for_id << poll.id
 			end
 		end
 		@polls_not_voted_for = []
 		polls_not_voted_for_id.each do |id|
 			@polls_not_voted_for << Poll.where(:id => id).first
 		end
	end

	def new 
		if !@current_user.admin_permissions
			redirect_to poll_index_path
		end
	end

	def create
		if @current_user.admin_permissions
		    if !params[:name].blank? && !params[:question].blank? && !params[:voting_op].blank? && params[:voting_op].count >= 2
		      new_poll = Poll.create :name => params[:name], :question => params[:question]
		      params[:voting_op].each do |voting_op|
		        PollOption.create :poll_id => new_poll.id, :name => voting_op[1]
		      end
		    end
		end
	    redirect_to poll_index_path
	end

	def show
		@poll = Poll.find_by_id params[:id]
	    poll_voting_opportunities_id = []
	    @poll_voting_absolute_results = []
	    @poll_voting_relative_results = []
	    poll_voting_opportunities_id = PollOption.where(:poll_id => @poll.id).pluck(:id)
	    poll_voting_opportunities_id.each do |op_id|
	      @poll_voting_absolute_results << PollVote.where(:poll_id => @poll.id, :poll_option_id => op_id).count
	    end
	    total_poll_votings = PollVote.where(:poll_id => @poll.id).count
	    @poll_voting_absolute_results.each do |counted_votes|
	      if total_poll_votings > 0
	      	@poll_voting_relative_results << ((counted_votes.to_f/total_poll_votings.to_f) * 100.to_f).round(2)
	      else
	        @poll_voting_relative_results << 0.0
	      end
	    end
	    @my_vote = PollVote.where(:poll_id => @poll.id, :student_id => @current_user.id).first
	end

  def vote_poll
    if !params[:poll_id].blank? && !params[:op_id].blank?
      if PollVote.where(:poll_id => params[:poll_id], :student_id => @current_user.id).count == 0
      	PollVote.create :poll_id => params[:poll_id], :poll_option_id => params[:op_id], :student_id => @current_user.id
      end
      redirect_to poll_path params[:poll_id]
    else
      redirect_to poll_index_path
    end
  end

  def remove_vote_poll
  	if !params[:poll_id].blank? && !params[:op_id].blank?
  		vote = PollVote.where(:poll_id => params[:poll_id], :poll_option_id => params[:op_id], :student_id => @current_user.id).first
  		if !vote.blank?
  			vote.delete
  		end
  		redirect_to poll_path params[:poll_id]
  	else
  		redirect_to poll_index_path
  	end
  end

  def add_poll_vote_options
    if !params[:poll_id].blank? && !params[:op].blank?
      PollOption.create :poll_id => params[:poll_id], :name => params[:op]
      redirect_to poll_path(params[:poll_id])
    else
      redirect_to poll_index_path
    end
  end

	def edit
		if @current_user.admin_permissions
			@poll = Poll.find_by_id params[:id]
		else
			poll_index_path
		end
	end

	def update
		if @current_user.admin_permissions
			if !params[:poll_id].blank? && !params[:name].blank? && !params[:question].blank? && !params[:voting_op].blank? && !params[:poll_option_id].blank?
				if Poll.find_by_id params[:poll_id]
					poll = Poll.find_by_id params[:poll_id]
					poll.update_attributes :name => params[:name], :question => params[:question]
					i = 0
					params[:voting_op].each do |voting_op|
						k = 0
						params[:poll_option_id].each do |poll_option_id|
							if k == i
								if !voting_op[1].blank?
									PollOption.find_by_id(poll_option_id[1].to_i).update_attributes :name => voting_op[1]
								else
									PollOption.find_by_id(poll_option_id[1].to_i).destroy
								end
							end
							k += 1
						end
						i += 1
					end
					redirect_to poll_path params[:poll_id]
				else
					redirect_to poll_index_path
				end
			else
				redirect_to poll_index_path
			end
		else
			redirect_to poll_index_path
		end
	end

    def destroy
	  	if @current_user.admin_permissions
		    if Poll.find_by_id params[:id]
		    	poll = Poll.find_by_id params[:id]
		      	poll.destroy
		    end
		end
	    redirect_to poll_index_path
    end

end