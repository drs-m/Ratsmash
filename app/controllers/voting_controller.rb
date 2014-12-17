# encoding: utf-8
class VotingController < ApplicationController

	before_action -> { check_session redirect: true }

	def home
		@not_ordered_descriptions = @current_user.descriptions.unchecked.present?

		@not_voted_polls = false
		polls_already_voted_for_id = PollVote.where(:student_id => @current_user.id).pluck(:poll_id)
 		Poll.all.each do |poll|
 			if !poll.closed
	 			if !poll.id.in? polls_already_voted_for_id
	 				@not_voted_polls = true
	 			end
	 		end
 		end
	end

	def get_newsticker_news
		actual_news = News.order(:updated_at).reverse.first(5)
		newsticker = []
		actual_news.each do |news|
			news_arr = [news.id,news.updated_at.day.to_s+"."+news.updated_at.month.to_s+"."+news.updated_at.year.to_s,news.subject]
			newsticker << news_arr
		end

		respond_to do |format|
		  	format.json { render json: newsticker }
		end
	end

	def results
		if @current_user.admin_permissions
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
		else
			flash[:error] = "Fuer das Einsehen der Ergebnisse des Kategorien-Votings hast du keine Rechte"
			redirect_to home_path
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
		@student_categories = Group.where(student: true, teacher: false).map(&:categories).flatten
		@teacher_categories = Group.where(student: false, teacher: true).map(&:categories).flatten
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
		flash[:error] = "Die Kategorie wurde nicht gefunden"
		redirect_to(give_vote_path(category_id: @category.id)) and return unless @category
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
			if !((1..3).include?(params[:rating].to_i))
				flash[:error] = "Rating (" + params[:rating] + ") zu hoch/niedrig!"
				redirect_to give_vote_path(category_id: @category.id)
			end

			#breche ab, wenn man für diese Person in dieser Kategorie nicht voten darf
			if votedIsAllowedForCategory
				#fahre nur fort, wenn man noch nicht in dieser kategorie für den gevoteten abgestimmt hat
				if !isAlreadyVotedFor
					#fahre nur fort, wenn gevoteter nicht man selbst ist
					if voted.id == @current_user.id && voted.class.to_s.downcase == "student"
						# umleitung zur abstimmungsseite mit dem hinweis, dass man nicht für sich selbst voten darf
						flash[:error] = "Du darfst nicht für dich selbst voten!"
						redirect_to give_vote_path(category_id: @category.id)
					else
						# abspeicherung der stimme
						@current_user.given_votes << voted.achieved_votes.build(category_id: @category.id, rating: params[:rating])

						# umleitung zur abstimmungsseite, sofern die stimmabgabe erfolgreich war
						redirect_to give_vote_path(category_id: @category.id), flash: {notice: "Voting erfolgreich"}
					end
				else
					# umleitung zur abstimmungsseite mit dem hinweis, dass man nicht zwei mail für den selben in einer kategorie voten darf
					flash[:error] = "Du kannst in einer Kategorie nicht mehrmals die selbe Person wählen!"
					redirect_to give_vote_path(category_id: @category.id)
				end
			else
				# umleitung zur abstimmungsseite mit dem hinweis, dass in dieser Kategorie nicht für diese Person gevotet werden darf
				flash[:error] = "Du darfst in dieser Kategorie nicht für " + voted.name + " voten. Ueberpruefe die Personeneigenschaften (Schueler-Lehrer ? / Maennlich-Weiblich ?) der Kategorie!"
				redirect_to give_vote_path(category_id: @category.id)
			end
		else
			# breche ab wenn kein kandidat gefunden wurde
			flash[:error] = "Der Kandidat " + params[:candidate] + " wurde nicht gefunden!"
			redirect_to give_vote_path(category_id: @category.id)
		end
	end

	def delete_vote
		#prüfe, ob Parameter category_id übergeben wurde
		if params[:category_id]
			#prüfe, ob Kategrie vorhanden ist
			if Category.find_by_id params[:category_id]
				@category = Category.find_by_id params[:category_id]
			else
				flash[:error] = "Vote konnte nicht geloescht werden. Unbekannte Kategorie!"
				redirect_to category_list_path
			end
		else
			flash[:error] = "Vote konnte nicht geloescht werden. Unbekannte Kategorie!"
			redirect_to category_list_path
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
						redirect_to give_vote_path(category_id: @category.id), flash: {notice: "Vote erfolgreich geloescht"}
					else
						flash[:error] = "Vote konnte nicht geloescht werden. Fehler im System. Versuche es bitte spaeter erneut!"
						redirect_to give_vote_path(category_id: @category.id)
					end
				else
					flash[:error] = "Du kannst den Vote nicht loeschen, da du ihn nicht selbst erstellt hast!"
					redirect_to give_vote_path(category_id: @category.id)
				end
			else
				flash[:error] = "Der zu loeschende Vote wurde nicht gefunden!"
				redirect_to give_vote_path(category_id: @category.id)
			end
		else
			flash[:error] = "Fehler im System: Parameter des zu loeschenden Votes wurden nicht übergeben. Bitte versuche es spaeter erneut!"
			redirect_to give_vote_path(category_id: @category.id)
		end
	end

	def display_error(options = {})
		@message = options[:message]
		@route_back = options[:route_back]
		render :error_while_voting
	end

end
