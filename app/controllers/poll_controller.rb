class PollController < ApplicationController

	before_action -> { check_session redirect: true, restricted_methods: [:new, :create, :edit, :update, :destroy, :open_poll, :close_poll, :add_poll_vote_options] }
	
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
			flash[:error] = "Du hast keine Administratorenrechte fuer das Erstellen von Umfragen!"
			redirect_to poll_index_path
		end
	end

	def create
		if @current_user.admin_permissions
		    if !params[:name].blank? && !params[:question].blank? && !params[:voting_op].blank? && params[:voting_op].count >= 2
		      new_poll = Poll.create :name => params[:name], :question => params[:question]
		      params[:voting_op].each do |voting_op|
		      	if !voting_op[1].blank?
		        	PollOption.create :poll_id => new_poll.id, :name => voting_op[1]
		        end
		      end
		      redirect_to poll_index_path, flash: {notice: "Umfrage wurde erfolgreich erstellt"}
		    else
		    	flash[:error] = "Du musst alle Felder ausfuellen und mindestens 2 Abstimmungsmoeglichkeiten angeben, um eine Umfrage erstellen zu koennen!"
		    	redirect_to poll_index_path
		    end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Erstellen von Umfragen!"
			redirect_to poll_index_path
		end
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

	def open_poll
		if @current_user.admin_permissions && Poll.find_by_id(params[:id]).closed
			if !params[:id].blank? && Poll.find_by_id(params[:id])
				poll = Poll.find_by_id params[:id]
				poll.update_attributes :closed => false
				redirect_to poll_path params[:id], flash: {notice: "Die Umfrage wurde erfolgreich wieder geoeffnet!"}
			else
				flash[:error] = "Fehler: Umfrage nicht gefunden! Bitte versuche es spaeter erneut!"
	      		redirect_to poll_index_path
			end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Oeffnen von Umfragen oder die Umfrage wurde bereits geoeffnet!"
			redirect_to poll_index_path
		end
	end

	def close_poll
		if @current_user.admin_permissions && !Poll.find_by_id(params[:id]).closed
			if !params[:id].blank? && Poll.find_by_id(params[:id])
				poll = Poll.find_by_id params[:id]
				poll.update_attributes :closed => true
				redirect_to poll_path params[:id], flash: {notice: "Die Umfrage wurde erfolgreich beendet!"}
			else
				flash[:error] = "Fehler: Umfrage nicht gefunden! Bitte versuche es spaeter erneut!"
	      		redirect_to poll_index_path
			end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Beenden von Umfragen oder die Umfrage wurde bereits beendet!"
			redirect_to poll_index_path
		end
	end

  def vote_poll
    if !params[:poll_id].blank? && !params[:op_id].blank? && !Poll.find_by_id(params[:poll_id]).closed
      if PollVote.where(:poll_id => params[:poll_id], :student_id => @current_user.id).count == 0
      	PollVote.create :poll_id => params[:poll_id], :poll_option_id => params[:op_id], :student_id => @current_user.id
      else
      	flash[:error] = "Du hast fuer diese Umfrage schon einmal abgestimmt!"
      	redirect_to poll_path params[:poll_id]
      end
      redirect_to poll_path params[:poll_id], flash: {notice: "Du hast erfolgreich bei der Umfrage abgestimmt"}
    else
      flash[:error] = "Fehler: Umfrage oder Abstimmungsmoeglichkeit nicht gefunden! Bitte versuche es spaeter erneut!"
      redirect_to poll_index_path
    end
  end

  def remove_vote_poll
  	if !params[:poll_id].blank? && !params[:op_id].blank?  && !Poll.find_by_id(params[:poll_id]).closed
  		vote = PollVote.where(:poll_id => params[:poll_id], :poll_option_id => params[:op_id], :student_id => @current_user.id).first
  		if !vote.blank?
  			vote.delete
  		else
  			flash[:error] = "Fehler: Umfrage, Abstimmungsmoeglichkeit oder Nutzer-ID nicht gefunden! Bitte versuche es spaeter erneut!"
  			redirect_to poll_index_path
  		end
  		redirect_to poll_path params[:poll_id], flash: {notice: "Abstimmung erfolgreich zurueckgezogen"}
  	else
  		flash[:error] = "Fehler: Umfrage oder Abstimmungsmoeglichkeit nicht gefunden! Bitte versuche es spaeter erneut!"
  		redirect_to poll_index_path
  	end
  end

  def add_poll_vote_options
    if !params[:poll_id].blank? && !params[:op].blank? && !Poll.find_by_id(params[:poll_id]).closed
      PollOption.create :poll_id => params[:poll_id], :name => params[:op]
      redirect_to poll_path params[:poll_id], flash: {notice: "Abstimmungsmoeglichkeit erfolgreich hinzugefuegt"}
    else
      flash[:error] = "Du musst alle Felder ausfuelen, um eine Abstimmungsmoeglichkeit hinzufuegen zu koennen!"
      redirect_to poll_index_path
    end
  end

	def edit
		if @current_user.admin_permissions && !Poll.find_by_id(params[:id]).closed
			@poll = Poll.find_by_id params[:id]
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Bearbeiten von Umfragen  oder die Umfrage wurde bereits beendet!"
			redirect_to poll_index_path
		end
	end

	def update
		if @current_user.admin_permissions && !Poll.find_by_id(params[:poll_id]).closed
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
									if voting_op[1] == PollOption.find_by_id(poll_option_id[1].to_i).name
										PollOption.find_by_id(poll_option_id[1].to_i).update_attributes :name => voting_op[1]
									else
										PollVote.where(:poll_id => poll.id, :poll_option_id => poll_option_id[1].to_i).each do |vote|
											vote.destroy
										end
										PollOption.find_by_id(poll_option_id[1].to_i).update_attributes :name => voting_op[1]
									end
								else
									PollOption.find_by_id(poll_option_id[1].to_i).destroy
								end
							end
							k += 1
						end
						i += 1
					end
					redirect_to poll_path params[:poll_id], flash: {notice: "Umfrage erfolgreich bearbeitet"}
				else
					flash[:error] = "Fehler: Umfrage nicht gefunden. Versuche es spaeter erneut!"
					redirect_to poll_index_path
				end
			else
				flash[:error] = "Fehler: Es konnten nicht alle Umfrageeigenschaften gefunden werden. Versuche es spaeter erneut!"
				redirect_to poll_index_path
			end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Bearbeiten von Umfragen  oder die Umfrage wurde bereits beendet!"
			redirect_to poll_index_path
		end
	end

    def destroy
	  	if @current_user.admin_permissions && !Poll.find_by_id(params[:id]).closed
		    if Poll.find_by_id params[:id]
		    	poll = Poll.find_by_id params[:id]
		      	poll.destroy
		      	redirect_to poll_index_path, flash: {notice: "Umfrage erfolgreich geloescht"}
		    else
		    	flash[:error] = "Fehler: Umfrage nicht gefunden. Versuche es spaeter erneut!"
		    	redirect_to poll_index_path
		    end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Loeschen von Umfragen oder die Umfrage wurde bereits beendet!"
			redirect_to poll_index_path
		end
    end

end