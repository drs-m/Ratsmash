# encoding: utf-8
class VotingController < ApplicationController

	before_action -> { check_session redirect: true }

	def results
		@categoryResults = []

		firstPlaceId = -1
		firstPlacePoints = 0
		secondPlaceId = -1
		secondPlacePoints = 0
		thirdPlaceId = -1
		thirdPlacePoints = 0
		@totalPoints = 0

		if params[:category_id]
			if Vote.where(:category_id => params[:category_id]).pluck(:rating).sum > 0
				@totalPoints = Vote.where(:category_id => params[:category_id]).pluck(:rating).sum

				#Alle
				if Category.find_by_id(params[:category_id]).group_id == 1
					Student.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					Teacher.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Alle Frauen
				if Category.find_by_id(params[:category_id]).group_id == 2
					Student.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					Teacher.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Alle Männer
				if Category.find_by_id(params[:category_id]).group_id == 3
					Student.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					Teacher.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Alle Schüler
				if Category.find_by_id(params[:category_id]).group_id == 4
					Student.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Schüler
				if Category.find_by_id(params[:category_id]).group_id == 6
					Student.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Schülerinnen
				if Category.find_by_id(params[:category_id]).group_id == 7
					Student.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end		

				#Alle Lehrer
				if Category.find_by_id(params[:category_id]).group_id == 5
					Teacher.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Lehrer
				if Category.find_by_id(params[:category_id]).group_id == 8
					Teacher.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Lehrerinnen
				if Category.find_by_id(params[:category_id]).group_id == 9
					Teacher.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							firstPlaceId = student.id
							firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							secondPlaceId = student.id
							secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end		
			else
				@categoryResults[0] = []
				@categoryResults[0][0] = 0
				@categoryResults[0][1] = 0
				@categoryResults[0][2] = 0
				@categoryResults[1] = []
				@categoryResults[1][0] = 0
				@categoryResults[1][1] = 0
				@categoryResults[1][2] = 0
				@categoryResults[2] = []
				@categoryResults[2][0] = 0
				@categoryResults[2][1] = 0
				@categoryResults[2][2] = 0
				@categoryResults[3] = []
				@categoryResults[3][0] = 0
				@categoryResults[3][1] = 0
			end

		else
			params[:category_id] = 1
			@categoryResults[0] = []
			@categoryResults[0][0] = 0
			@categoryResults[0][1] = 0
			@categoryResults[0][2] = 0
			@categoryResults[1] = []
			@categoryResults[1][0] = 0
			@categoryResults[1][1] = 0
			@categoryResults[1][2] = 0
			@categoryResults[2] = []
			@categoryResults[2][0] = 0
			@categoryResults[2][1] = 0
			@categoryResults[2][2] = 0
			@categoryResults[3] = []
			@categoryResults[3][0] = 0
			@categoryResults[3][1] = 0
		end

		@results = []
		Category.ids.each { |category_id| @results << {category_id: category_id, ranking: Vote.connection.select_all("select name, sum(rating) as points from votes v inner join students s on v.voted_id = s.id where v.category_id = #{category_id} group by name order by points desc limit 3").to_a } }
	end

	def autocomplete
		# Beispiel: /vote/autocomplete.json?p=&q=a&c=31

		redirect_to :home unless params[:format] == "json"

		# check if searchstring and category are provided
		@error = "too few arguments provided" and return render unless params[:q] && params[:c]
		category = Category.find_by id: params[:c]
		# breche ab wenn keine kategorie gefunden wurde
		@error = "category not found" and return render unless category

		@results = []
		# xor
		if category.group.male ^ category.group.female
			@results += Student.name_search(params[:q]).where(gender: category.group.male, closed: false).to_a if category.group.student
			@results += Teacher.name_search(params[:q]).where(gender: category.group.male, closed: false).to_a if category.group.teacher
		else
			@results += Student.name_search(params[:q]).where(closed: false).to_a if category.group.student
			@results += Teacher.name_search(params[:q]).where(closed: false).to_a if category.group.teacher
		end

		# übersichtlichere ausgabe wenn ?p= angegeben wurde (PrettyPrint)
		render(:json => JSON.pretty_generate(JSON.parse(render_to_string))) and return if params[:p]
		
		# --> voting/autocomplete.json.jbuilder
	end
	
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
		@categories_all = Group.everyone.categories
		@categories_all_female = Group.all_female.categories
		@categories_all_male = Group.all_male.categories
	
		@categories_student_all = Group.all_students.categories
		@categories_student_female = Group.female_students.categories
		@categories_student_male = Group.male_students.categories
	
		@categories_teacher_all = Group.all_teachers.categories
		@categories_teacher_female = Group.female_teachers.categories
		@categories_teacher_male = Group.male_teachers.categories
	end

	def choose
		@category = Category.find_by_id(params[:category_id])
		display_error(message: "Die Kategorie wurde nicht gefunden!", back: :category_list) and return unless @category

		@given_votes = Vote.by_voter_in_category voter: @current_user, category: @category
	end

	def commit
		@category = Category.find_by_id(params[:category_id])
		redirect_to(give_vote_path(category_id: @category.id), notice: "Die Kategorie wurde nicht gefunden!") and return unless @category
		
		# find the voted account by searching in student db first and in teacher db if nothing has been found
		voted = Student.find_by name: params[:candidate]
		voted = Teacher.find_by name: params[:candidate] unless voted

		if voted
			# breche ab wenn das rating zu hoch/niedrig ist
			redirect_to(give_vote_path(category_id: @category.id), notice: "Rating (" + params[:rating] + ") zu hoch/niedrig!") and return unless (1..3).include?(params[:rating].to_i)

			# abspeicherung der stimme
			@current_user.given_votes << voted.achieved_votes.build(category_id: @category.id, rating: params[:rating])
			
			# umleitung zur abstimmungsseite, sofern die stimmabgabe erfolgreich war
			redirect_to give_vote_path(category_id: @category.id), notice: "Erfolgreich abgestimmt"
		else
			# breche ab wenn kein kandidat gefunden wurde
			redirect_to give_vote_path(category_id: @category.id), notice: "Der Kandidat " + params[:candidate] + " wurde nicht gefunden!"
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
		@route_back = options[:route_back]
		render :error_while_voting
	end

end
