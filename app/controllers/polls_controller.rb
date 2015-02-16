class PollsController < ApplicationController

	before_action -> { check_session redirect: true, restricted_methods: [:new, :create, :edit, :update, :destroy, :open_poll, :close_poll] }

	def index
 		@polls = {
			voted: Poll.voted_for(@current_user),
			not_voted: Poll.not_voted_for(@current_user)
		}
	end

	def new

	end

	def create
		if !params[:name].blank? && !params[:question].blank? && !params[:voting_ops].blank? && params[:voting_ops].count >= 2
			new_poll = Poll.create :name => params[:name], :question => params[:question]
			params[:voting_ops].each do |voting_op|
				if voting_op[1].present?
					PollOption.create :poll_id => new_poll.id, :name => voting_op[1]
				end
			end
			redirect_to :polls, flash: {notice: "Umfrage wurde erfolgreich erstellt"}
		else
			flash[:error] = "Du musst alle Felder ausfuellen und mindestens 2 Abstimmungsmoeglichkeiten angeben, um eine Umfrage erstellen zu koennen!"
			redirect_to :polls
		end
	end

	def vote
		@poll = Poll.find(params[:poll_id])
		if request.post?
			if params[:chosen].present?
				if params[:chosen].count > @poll.possible_votes
					flash[:error] = "Du hast zu viele Optionen gewählt"
					redirect_to vote_poll_path(poll_id: @poll.id)
					return
				end

				poll_votes = params[:chosen].map { |id| PollOption.find(id).votes.create(student_id: @current_user.id) }

			else
				flash[:error] = "Bitte wähle mindestens eine Option"
				redirect_to vote_poll_path(poll_id: @poll.id)
			end
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
	      		redirect_to :polls
			end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Oeffnen von Umfragen oder die Umfrage wurde bereits geoeffnet!"
			redirect_to :polls
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
	      		redirect_to :polls
			end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Beenden von Umfragen oder die Umfrage wurde bereits beendet!"
			redirect_to :polls
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
      redirect_to :polls
    end
  end

  def remove_vote_poll
  	if !params[:poll_id].blank? && !params[:op_id].blank?  && !Poll.find_by_id(params[:poll_id]).closed
  		vote = PollVote.where(:poll_id => params[:poll_id], :poll_option_id => params[:op_id], :student_id => @current_user.id).first
  		if !vote.blank?
  			vote.delete
  		else
  			flash[:error] = "Fehler: Umfrage, Abstimmungsmoeglichkeit oder Nutzer-ID nicht gefunden! Bitte versuche es spaeter erneut!"
  			redirect_to :polls
  		end
  		redirect_to poll_path params[:poll_id], flash: {notice: "Abstimmung erfolgreich zurueckgezogen"}
  	else
  		flash[:error] = "Fehler: Umfrage oder Abstimmungsmoeglichkeit nicht gefunden! Bitte versuche es spaeter erneut!"
  		redirect_to :polls
  	end
  end

	def edit
		if @current_user.admin_permissions && !Poll.find_by_id(params[:id]).closed
			@poll = Poll.find_by_id params[:id]
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Bearbeiten von Umfragen  oder die Umfrage wurde bereits beendet!"
			redirect_to :polls
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
					redirect_to :polls
				end
			else
				flash[:error] = "Fehler: Es konnten nicht alle Umfrageeigenschaften gefunden werden. Versuche es spaeter erneut!"
				redirect_to :polls
			end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Bearbeiten von Umfragen  oder die Umfrage wurde bereits beendet!"
			redirect_to :polls
		end
	end

    def destroy
	  	if @current_user.admin_permissions && !Poll.find_by_id(params[:id]).closed
		    if Poll.find_by_id params[:id]
		    	poll = Poll.find_by_id params[:id]
		      	poll.destroy
		      	redirect_to :polls, flash: {notice: "Umfrage erfolgreich geloescht"}
		    else
		    	flash[:error] = "Fehler: Umfrage nicht gefunden. Versuche es spaeter erneut!"
		    	redirect_to :polls
		    end
		else
			flash[:error] = "Du hast keine Administratorenrechte fuer das Loeschen von Umfragen oder die Umfrage wurde bereits beendet!"
			redirect_to :polls
		end
    end

end
