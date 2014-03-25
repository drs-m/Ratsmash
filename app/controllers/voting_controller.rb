class VotingController < ApplicationController

	before_action :check_session

	def menu

	end

	def edit
		@update_category_id = params[:category_id]
		my_votings @update_category_id
	end

	def update

	end

	def vote
		is_voted = false
		candidate_id = nil
		is_already_voted_for = false
		if !params[:my_vote_name].blank?
			account_id = @u_account.id
			category_id = params[:category_id]
			rating = params[:rating]

			if Vote.where(:profile_id => account_id, :category_id => category_id, :rating => params[:rating]).count > 0
				is_voted = true
			end

			my_votings(category_id)

			for vote in @votes_for_this_category
				if vote == params[:my_vote_name]
					is_already_voted_for = true
				end
			end

			if !is_voted
				if !is_already_voted_for
					Profile.all.each do |profile| 
						if profile.name.downcase == params[:my_vote_name].downcase
							candidate_id = profile.id
							break
						end
					end

					if !candidate_id.blank?
						if candidate_id != account_id
							createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
							createNewVote.save
							if !createNewVote.new_record?
								redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
							else 
								flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es später erneut!'
								redirect_to :back
							end
						else 
							flash[:warning] =  'Du kannst nicht für dich selbst voten!'
							redirect_to :back
						end
					else 
						flash[:warning] = 'Name nicht vorhanden!'
						redirect_to :back
					end
				else
					flash[:warning] = params[:my_vote_name] + ' belegt schon einen Platz in deinem Voting für diese Kategorie!'
					redirect_to :back
				end
			else 
				ranking = 4 - params[:rating].to_i
				flash[:warning] = 'Für den ' + ranking.to_s + '. Platz dieser Kategorie hast du schon gevotet!'
				redirect_to :back
			end
		else 
			redirect_to :back
		end
	end

	def list
		# ordne die Kategorien so, dass erst Schülerkategorien und dann Lehrerkategorien erscheinen
		@categories = Category.order(:applies_to_teacher)
	end

	def choose
		# lade ausgewählte kategorie für den View anhand der aus der URL stammenden id
		@category = Category.find_by_id(params[:category_id])
		my_votings(@category.id)
	end

	def my_votings
		first_vote = Vote.where(:profile_id => @u_account.id, :category_id => category_id, :rating => 3).pluck(:candidate_id)
		first_vote_name = Profile.id(first_vote)

		second_vote = Vote.where(:profile_id => @u_account.id, :category_id => category_id, :rating => 2).pluck(:candidate_id)
		second_vote_name = Profile.id(second_vote)

		third_vote = Vote.where(:profile_id => @u_account.id, :category_id => category_id, :rating => 1).pluck(:candidate_id)
		third_vote_name = Profile.id(third_vote)

		@votes_for_this_category = [first_vote_name,second_vote_name,third_vote_name]
	end

end
