# encoding: utf-8
class VotingController < ApplicationController

	before_action :check_session

	
	def menu
		
	end

	def edit
		if !params[:typedIn].nil?
			@search_name_error = false
			@id = params[:id]
			@id2 = params[:id2]
			
			#@possible_names = Profile.where('first_name like ? OR last_name like ?', '%'+params[:typedIn]+'%', '%'+params[:typedIn]+'%')

			@possible_names = []

			cat_type = Category.find_by_id(params[:category_id]).cat_type

			Profile.all.each do |profile|
				if profile.name.downcase.include? params[:typedIn].downcase

					if cat_type == "all_all"
						@possible_names << profile.name
					else 
						if cat_type == "all_male"
							if profile.gender
								@possible_names << profile.name
							end
						end

						if cat_type == "all_female"
							if !profile.gender
								@possible_names << profile.name
							end
						end

						if cat_type == "pupil_all"
							if !profile.teacher
								@possible_names << profile.name
							end
						end

						if cat_type == "pupil_male"
							if !profile.teacher && profile.gender
								@possible_names << profile.name
							end
						end

						if cat_type == "pupil_female"
							if !profile.teacher && !profile.gender
								@possible_names << profile.name
							end
						end

						if cat_type == "teacher_all"
							if profile.teacher
								@possible_names << profile.name
							end
						end

						if cat_type == "teacher_male"
							if profile.teacher && profile.gender
								@possible_names << profile.name
							end
						end

						if cat_type == "teacher_female"
							if profile.teacher && !profile.gender
								@possible_names << profile.name
							end
						end

					end

				end
			end

			@possible_names = @possible_names.sort

			if @possible_names.empty?
				@possible_names = ["Name nicht vorhanden oder nicht zulÃ¤ssig fÃ¼r diese Kategorie"]
			end

			render :partial => 'possible_names'
		else 
			@update_category_id = params[:category_id]
			my_votings @update_category_id
		end
	end

	def update
		candidate_id = nil
		hadToDeleteOtherVote = false
		if !params[:my_vote_name].blank?
			account_id = @u_account.id
			category_id = params[:category_id]
			rating = params[:rating]

			if Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).count > 0
				Profile.all.each do |profile|
					if profile.name.downcase == params[:my_vote_name].downcase
						candidate_id = profile.id
						break
					end
				end

				if !candidate_id.blank?
					if candidate_id != account_id
						my_votings(category_id)

						for vote in @votes_for_this_category
							if vote.downcase == params[:my_vote_name].downcase
								deleteVote = Vote.where(:profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id)
								deleteVoteRating = deleteVote.pluck(:rating)
								if deleteVoteRating.first.to_i != rating.to_i
									deleteVote.first.delete
									hadToDeleteOtherVote = true
								end
								break
							end
						end

						cat_type = Category.find_by_id(category_id).cat_type

						if cat_type == "all_all"
							vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
							vote.update_attributes(:candidate_id => candidate_id)
							if !vote.changed?
								if !hadToDeleteOtherVote
									redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
								else 
									redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
								end
							else 
								flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
								redirect_to :back
							end
						else 
							if cat_type == "all_male"
								if Profile.find_by_id(candidate_id).gender
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r mÃ¤nnliche Kandidaten voten!'
									redirect_to :back
								end 
							end

							if cat_type == "all_female"
								if !Profile.find_by_id(candidate_id).gender
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r weibliche Kandidaten voten!'
									redirect_to :back
								end
							end

							if cat_type == "pupil_all"
								if !Profile.find_by_id(candidate_id).teacher
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r SchÃ¼ler voten!'
									redirect_to :back
								end
							end

							if cat_type == "pupil_male"
								if !Profile.find_by_id(candidate_id).teacher && Profile.find_by_id(candidate_id).gender
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r mÃ¤nnliche SchÃ¼ler voten!'
									redirect_to :back
								end
							end

							if cat_type == "pupil_female"
								if !Profile.find_by_id(candidate_id).teacher && !Profile.find_by_id(candidate_id).gender
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r weibliche SchÃ¼ler voten!'
									redirect_to :back
								end
							end

							if cat_type == "teacher_all"
								if Profile.find_by_id(candidate_id).teacher
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r Lehrer voten!'
									redirect_to :back
								end
							end

							if cat_type == "teacher_male"
								if Profile.find_by_id(candidate_id).teacher && Profile.find_by_id(candidate_id).gender
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r mÃ¤nnliche Lehrer voten!'
									redirect_to :back
								end
							end

							if cat_type == "teacher_female"
								if Profile.find_by_id(candidate_id).teacher && !Profile.find_by_id(candidate_id).gender
									vote = Vote.where(:profile_id => account_id, :category_id => category_id, :rating => rating).first
									vote.update_attributes(:candidate_id => candidate_id)
									if !vote.changed?
										if !hadToDeleteOtherVote
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet!'
										else 
											redirect_to :back, :notice => 'Voting erfolgreich bearbeitet! Da es sonst zu einem doppelten Voting gekommen wÃ¤re, wurde das alte Voting fÃ¼r den Selben Kandidaten gelÃ¶scht! (siehe Hinweis "Achtung")'
										end
									else 
										flash[:warning] =  'Fehler im System. Voting konnte nicht bearbeitet werden!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r weibliche Lehrer voten!'
									redirect_to :back
								end
							end

						end

					else 
						flash[:warning] =  'Du kannst nicht fÃ¼r dich selbst voten!'
						redirect_to :back
					end 
				else 
					flash[:warning] =  'Name nicht vorhanden!'
					redirect_to :back
				end
			else 
				flash[:warning] =  'Fehler im System. Zu bearbeitender Datensatz konnte nicht gefunden werden!'
				redirect_to :back	
			end
		else 
			redirect_to :back
		end		
	end

	def vote
		candidate_id = nil
		is_already_voted_for = false
		if !params[:my_vote_name].blank?
			account_id = @u_account.id
			category_id = params[:category_id]
			rating = params[:rating]

			my_votings(category_id)

			for vote in @votes_for_this_category
				if vote.downcase == params[:my_vote_name].downcase
					is_already_voted_for = true
				end
			end

			if !is_already_voted_for
				Profile.all.each do |profile| 
					if profile.name.downcase == params[:my_vote_name].downcase
						candidate_id = profile.id
						break
					end
				end

				if !candidate_id.blank?
					if candidate_id != account_id
						cat_type = Category.find_by_id(category_id).cat_type
						if cat_type == "all_all"
							createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
							createNewVote.save
							if !createNewVote.new_record?
								redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
							else 
								flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
								redirect_to :back
							end
						else 
							if cat_type == "all_male"
								if Profile.find_by_id(candidate_id).gender
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r mÃ¤nnliche Kandidaten voten!'
									redirect_to :back
								end
							end

							if cat_type == "all_female"
								if !Profile.find_by_id(candidate_id).gender
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r weibliche Kandidaten voten!'
									redirect_to :back
								end
							end

							if cat_type == "pupil_all"
								if !Profile.find_by_id(candidate_id).teacher
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r SchÃ¼ler voten!'
									redirect_to :back
								end
							end

							if cat_type == "pupil_male"
								if !Profile.find_by_id(candidate_id).teacher && Profile.find_by_id(candidate_id).gender
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r mÃ¤nnliche SchÃ¼ler voten!'
									redirect_to :back
								end
							end

							if cat_type == "pupil_female"
								if !Profile.find_by_id(candidate_id).teacher && !Profile.find_by_id(candidate_id).gender
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r weibliche SchÃ¼ler voten!'
									redirect_to :back
								end
							end

							if cat_type == "teacher_all"
								if Profile.find_by_id(candidate_id).teacher
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r Lehrer voten!'
									redirect_to :back
								end
							end

							if cat_type == "teacher_male"
								if Profile.find_by_id(candidate_id).teacher && Profile.find_by_id(candidate_id).gender
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r mÃ¤nnliche Lehrer voten!'
									redirect_to :back
								end
							end

							if cat_type == "teacher_female"
								if Profile.find_by_id(candidate_id).teacher && !Profile.find_by_id(candidate_id).gender
									createNewVote = Vote.new :profile_id => account_id, :candidate_id => candidate_id, :category_id => category_id, :rating => rating
									createNewVote.save
									if !createNewVote.new_record?
										redirect_to :back, :notice => 'Voting erfolgreich abgeschlossen'
									else 
										flash[:warning] =  'Fehler beim Speichern des Votings. Versuchen Sie es spÃ¤ter erneut!'
										redirect_to :back
									end
								else 
									flash[:warning] =  'Bei dieser Kategorie kannst du nur fÃ¼r weibliche Lehrer voten!'
									redirect_to :back
								end
							end

						end
					else 
						flash[:warning] =  'Du kannst nicht fÃ¼r dich selbst voten!'
						redirect_to :back
					end
				else 
					flash[:warning] = 'Name nicht vorhanden!'
					redirect_to :back
				end
			else
				flash[:warning] = params[:my_vote_name] + ' belegt schon einen Platz in deinem Voting fÃ¼r diese Kategorie!'
				redirect_to :back
			end
		else 
			redirect_to :back
		end
	end

	def list
		# ordnen der Kategorien nach Typ
		@categories_all = Category.where(student: true, teacher: true, male: true, female: true)
		@categories_all_male = Category.where(student: true, teacher: true, male: true, female: false)
		@categories_all_female = Category.where(student: true, teacher: true, male: false, female: true)

		@categories_student_all = Category.where(student: true, teacher: false, male: true, female: true)
		@categories_student_male = Category.where(student: true, teacher: false, male: true, female: false)
		@categories_student_female = Category.where(student: true, teacher: false, male: false, female: true)

		@categories_teacher_all = Category.where(student: false, teacher: true, male: true, female: true)
		@categories_teacher_male = Category.where(student: false, teacher: true, male: true, female: false)
		@categories_teacher_female = Category.where(student: false, teacher: true, male: false, female: true)
	end

	def choose
		@category = Category.find_by_id(params[:category_id])
		display_error(message: "Die Kategorie wurde nicht gefunden!", back: :category_list) and return unless @category

		@given_votes = Vote.by_voter_in_category voter: @current_user, category: @category
	end

	def commit
		@category = Category.find_by_id(params[:category_id])
		display_error(message: "Die Kategorie wurde nicht gefunden!", back: :category_list) and return unless @category
		
		voted = Student.find_by name: params[:name]
		voted = Teacher.find_by name: params[:name] unless voted

		if voted
			# breche ab wenn das rating zu hoch/niedrig ist
			display_error(message: "Rating (" + params[:rating] + ") falsch!", back: give_vote_path(category_id: @category.id)) and return unless (1..3).include?(params[:rating].to_i)

			# umleitung zur abstimmungsseite, sofern die stimmabgabe erfolgreich war
			redirect_to give_vote_path(category_id: @category.id), notice: "Erfolgreich abgestimmt"
		else
			# breche ab wenn kein kandidat gefunden wurde
			display_error message: "Der Kandidat " + params[:name] + " wurde nicht gefunden!", back: give_vote_path(category_id: @category.id)
			render :error_while_voting, notice: "Der Kandidat " + params[:name] + " wurde nicht gefunden!"
		end
	end

	def delete_vote
		if !params[:candidate_id].blank? || !params[:category_id].blank? || !params[:rating].blank? 
			vote = Vote.where(:profile_id => @u_account.id, :candidate_id => params[:candidate_id], :category_id => params[:category_id], :rating => params[:rating]).first
			vote.delete
			if vote.destroyed?
				redirect_to :back, :notice => 'LÃ¶schen des Votes erfolgreich'
			else
				flash[:warning] = 'Fehler im System. Datensatz konnte nicht gelÃ¶scht werden!'
				redirect_to :back
			end
		else 
			redirect_to "/vote"
		end 
	end

	def display_error(options = {})
		@message = options[:message]
		@back_route = options[:back]
		render :error_while_voting
	end

end
