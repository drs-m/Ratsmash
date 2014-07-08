# encoding: utf-8
class VotingController < ApplicationController

	before_action -> { check_session redirect: true }

	def home
		@descriptions_status = @current_user.descriptions.unchecked.empty? ? "keine ungeordneten Beschreibungen" : "Du hast noch nicht eingeordnete Beschreibungen"
	end

	def results
		@results_s = []
		@results_t = []
		@results = []
		Category.ids.each do |category_id|
			if Category.find_by_id(category_id).group.student && !Category.find_by_id(category_id).group.teacher
				@results << {category_id: category_id, ranking: Vote.connection.select_all("select name, sum(rating) as points from votes v inner join students s on v.voted_id = s.id where v.category_id = #{category_id} group by name order by points desc limit 3").to_a } 
			elsif !Category.find_by_id(category_id).group.student && Category.find_by_id(category_id).group.teacher
				@results << {category_id: category_id, ranking: Vote.connection.select_all("select name, sum(rating) as points from votes v inner join teachers t on v.voted_id = t.id where v.category_id = #{category_id} group by name order by points desc limit 3").to_a }
			elsif Category.find_by_id(category_id).group.student && Category.find_by_id(category_id).group.teacher
				#besten 3 schüler der Kategorie
				@results << {category_id: category_id, ranking: Vote.connection.select_all("select name, sum(rating) as points from votes v inner join students s on v.voted_id = s.id where v.category_id = #{category_id} group by name order by points desc limit 3").to_a }
				#besten 3 lehrer der kategorie
				@results << {category_id: category_id, ranking: Vote.connection.select_all("select name, sum(rating) as points from votes v inner join teachers t on v.voted_id = t.id where v.category_id = #{category_id} group by name order by points desc limit 3").to_a }
				#results_s und results_t einzelnt durchlaufen und in neuem array gemeinsam speichern
				#dann im neuen array bei jeder category_id länge des rankings abfragen, wenn größer als 3, dann eintrag (name und points, also :ranking) mit den geringsten points löschen
			end
		end
	end

	def autocomplete
		# Beispiel: /vote/autocomplete.json?p=&q=a&c=31

		redirect_to :home unless params[:format] == "json"

		category = Category.find_by id: params[:c]
		# wenn keine kategorie gefunden wurde, dann alle möglichen namen ausgeben
		@results = []
		if category
			# xor
			if category.group.male ^ category.group.female
				@results += Student.name_search(params[:q]).where(gender: category.group.male, closed: false).to_a if category.group.student
				@results += Teacher.name_search(params[:q]).where(gender: category.group.male, closed: false).to_a if category.group.teacher
			else
				@results += Student.name_search(params[:q]).where(closed: false).to_a if category.group.student
				@results += Teacher.name_search(params[:q]).where(closed: false).to_a if category.group.teacher
			end
		else
			@results += Student.name_search(params[:q]).to_a
		end

		# übersichtlichere ausgabe wenn ?p= angegeben wurde (PrettyPrint)
		render(:json => JSON.pretty_generate(JSON.parse(render_to_string))) and return if params[:p]
		
		# --> voting/autocomplete.json.jbuilder
	end
	
	def menu
		
	end

	def list
		@groupset = [[Group.everyone, Group.all_female, Group.all_male], [Group.all_students, Group.female_students, Group.male_students], [Group.all_teachers, Group.female_teachers, Group.male_teachers]]
	end

	def choose
		@category = Category.find_by_id(params[:category_id])
		display_error(message: "Die Kategorie wurde nicht gefunden!", back: :category_list) and return unless @category

		@given_votes = Vote.by_voter_in_category voter: @current_user, category: @category
	end

	def commit
		votedIsAllowedForCategory = true
		isAlreadyVotedFor = false
		@category = Category.find_by_id(params[:category_id])
		redirect_to(give_vote_path(category_id: @category.id), notice: "Die Kategorie wurde nicht gefunden!") and return unless @category
		if @category.closed
			display_error(message: "Diese Kategorie ist momentan gesperrt!", back: :category_list) and return
		end
		
		# find the voted account by searching in student db first and in teacher db if nothing has been found
		voted = Student.find_by name: params[:candidate]
		voted = Teacher.find_by name: params[:candidate] unless voted

		if voted
			#erhalte vom voter abgebene votes zu dieser kategorie
			@given_votes = Vote.by_voter_in_category voter: @current_user, category: @category

			#prüfe, ob bei den schon abgegebenen votes jetzt ein doppelvote entstehen würde
			if @given_votes.count > 0
				@given_votes.each do |vote|
					if vote != nil
						if vote.voted_id == voted.id && voted.class.to_s.downcase == vote.voted_type.to_s.downcase
							isAlreadyVotedFor = true
						end
					end
				end
			end

			#prüfe, ob für diese Person in dieser Kategorie gevotet werden darf
			if @category.group.student && @category.group.teacher && !@category.group.male && @category.group.female
				if !voted.female 
					votedIsAllowedForCategory = false
				end
			elsif @category.group.student && @category.group.teacher && @category.group.male && !@category.group.female
				if !voted.male 
					votedIsAllowedForCategory = false
				end
			elsif @category.group.student && !@category.group.teacher && @category.group.male && @category.group.female
				if voted.class.to_s.downcase != "student"
					votedIsAllowedForCategory = false
				end
			elsif !@category.group.student && @category.group.teacher && @category.group.male && @category.group.female
				if voted.class.to_s.downcase != "teacher"
					votedIsAllowedForCategory = false
				end
			elsif @category.group.student && !@category.group.teacher && !@category.group.male && @category.group.female
				if voted.class.to_s.downcase != "student" || !voted.female
					votedIsAllowedForCategory = false
				end
			elsif @category.group.student && !@category.group.teacher && @category.group.male && !@category.group.female
				if voted.class.to_s.downcase != "student" || !voted.male
					votedIsAllowedForCategory = false
				end
			elsif !@category.group.student && @category.group.teacher && !@category.group.male && @category.group.female
				if voted.class.to_s.downcase != "teacher" || !voted.female
					votedIsAllowedForCategory = false
				end
			elsif !@category.group.student && @category.group.teacher && @category.group.male && !@category.group.female
				if voted.class.to_s.downcase != "teacher" || !voted.male
					votedIsAllowedForCategory = false
				end
			end

			# breche ab wenn das rating zu hoch/niedrig ist
			redirect_to(give_vote_path(category_id: @category.id), notice: "Rating (" + params[:rating] + ") zu hoch/niedrig!") and return unless (1..3).include?(params[:rating].to_i)

			#breche ab, wenn man für diese Person in dieser Kategorie nicht voten darf
			if votedIsAllowedForCategory
				#fahre nur fort, wenn man noch nicht in dieser kategorie für den gevoteten abgestimmt hat
				if !isAlreadyVotedFor
					#fahre nur fort, wenn gevoteter nicht man selbst ist
					if voted.id == @current_user.id && voted.class.to_s.downcase == "student"
						# umleitung zur abstimmungsseite mit dem hinweis, dass man nicht für sich selbst voten darf
						redirect_to give_vote_path(category_id: @category.id), notice: "Du darfst nicht für dich selbst voten"
					else
						# abspeicherung der stimme
						@current_user.given_votes << voted.achieved_votes.build(category_id: @category.id, rating: params[:rating])
						
						# umleitung zur abstimmungsseite, sofern die stimmabgabe erfolgreich war
						redirect_to give_vote_path(category_id: @category.id), notice: "Erfolgreich abgestimmt"
					end
				else
					# umleitung zur abstimmungsseite mit dem hinweis, dass man nicht zwei mail für den selben in einer kategorie voten darf
					redirect_to give_vote_path(category_id: @category.id), notice: "Du darfst nicht mehrmals mail für den Selben in einer Kategorie voten"
				end
			else
				# umleitung zur abstimmungsseite mit dem hinweis, dass in dieser Kategorie nicht für diese Person gevotet werden darf
				redirect_to give_vote_path(category_id: @category.id), notice: "Du darfst in dieser Kategorie nicht für " + voted.name + " voten"
			end
		else
			# breche ab wenn kein kandidat gefunden wurde
			redirect_to give_vote_path(category_id: @category.id), notice: "Der Kandidat " + params[:candidate] + " wurde nicht gefunden!"
		end
	end

	def delete_vote
		#prüfe, ob Parameter category_id übergeben wurde
		if params[:category_id]
			#prüfe, ob Kategrie vorhanden ist
			if Category.find_by_id params[:category_id]
				@category = Category.find_by_id params[:category_id]
			else
				redirect_to category_list_path, notice: "Vote konnte nicht gelöscht werden. Unbekannte Kategorie!"
			end
		else
			redirect_to category_list_path, notice: "Vote konnte nicht gelöscht werden. Unbekannte Kategorie!"
		end
		#prüfe, ob Parameter vote_id übergeben wurden
		if params[:vote_id]
			#prüfe, ob Vote vorhanden ist
			if Vote.find_by_id params[:vote_id]
				#prüfe, ob angemeldeter Benutzer Vote selbst erstellt hat
				if Vote.find_by_id(params[:vote_id]).voter_id == @current_user.id || Vote.find_by_id(params[:vote_id]).voter_id.class.to_s.downcase == @current_user.class.to_s.downcase
					vote = Vote.find_by_id params[:vote_id]
					vote. delete
					#prüfe, ob Löschung erfolgreich war
					if !Vote.find_by_id params[:vote_id]
						redirect_to give_vote_path(category_id: @category.id), notice: "Vote erfolgreich gelöscht!"
					else
						redirect_to give_vote_path(category_id: @category.id), notice: "Vote konnte nicht gelöscht werden. Fehler im System. Versuche es bitte später erneut!"
					end
				else
					redirect_to give_vote_path(category_id: @category.id), notice: "Du kannst den Vote nicht löschen, da du ihn nicht selbst erstellt hast!"
				end
			else
				redirect_to give_vote_path(category_id: @category.id), notice: "Der zu löschende Vote wurde nicht gefunden!"
			end
		else
			redirect_to give_vote_path(category_id: @category.id)
		end
	end

	def display_error(options = {})
		@message = options[:message]
		@route_back = options[:route_back]
		render :error_while_voting
	end

end