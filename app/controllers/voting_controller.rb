# encoding: utf-8
class VotingController < ApplicationController

	before_action -> { check_session redirect: true }

	def home
		@descriptions_status = "keine ungeordneten Beschreibungen"

		if Description.where(:for_id => @current_user.id, :status => 0).count > 0
			@descriptions_status = "Du hast noch nicht eingeordnete Beschreibungen"
		end
	end

	def results
		@categoryResults = []

		firstPlaceId = -1
		firstPlacePoints = 0
		firstPlaceVotedType = "student"
		secondPlaceId = -1
		secondPlacePoints = 0
		secondPlaceVotedType = "student"
		thirdPlaceId = -1
		thirdPlacePoints = 0
		thirdPlaceVotedType = "student"
		@totalPoints = 0

		if params[:category_id]
			if Vote.where(:category_id => params[:category_id]).pluck(:rating).sum > 0
				@totalPoints = Vote.where(:category_id => params[:category_id]).pluck(:rating).sum

				#Alle
				if Category.find_by_id(params[:category_id]).group_id == 1
					Student.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "student"
						end
					end

					Teacher.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "teacher"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Alle Frauen
				if Category.find_by_id(params[:category_id]).group_id == 2
					Student.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "student"
						end
					end

					Teacher.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "teacher"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Alle Männer
				if Category.find_by_id(params[:category_id]).group_id == 3
					Student.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "student"
						end
					end

					Teacher.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "teacher"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Alle Schüler
				if Category.find_by_id(params[:category_id]).group_id == 4
					Student.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "student"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Schüler
				if Category.find_by_id(params[:category_id]).group_id == 6
					Student.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "student"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Schülerinnen
				if Category.find_by_id(params[:category_id]).group_id == 7
					Student.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "student"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "student"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "student"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end		

				#Alle Lehrer
				if Category.find_by_id(params[:category_id]).group_id == 5
					Teacher.all.each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "teacher"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Lehrer
				if Category.find_by_id(params[:category_id]).group_id == 8
					Teacher.where(:gender => true).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "teacher"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end

				#Lehrerinnen
				if Category.find_by_id(params[:category_id]).group_id == 9
					Teacher.where(:gender => false).each do |student|
						if Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > firstPlacePoints
							if firstPlaceId != -1
								if secondPlaceId != -1
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									thirdPlaceId = secondPlaceId
									thirdPlacePoints = secondPlacePoints
									thirdPlaceVotedType = secondPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								else
									secondPlaceId = firstPlaceId
									secondPlacePoints = firstPlacePoints
									secondPlaceVotedType = firstPlaceVotedType
									firstPlaceId = student.id
									firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
									firstPlaceVotedType = "teacher"
								end
							else
								firstPlaceId = student.id
								firstPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								firstPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > secondPlacePoints
							if secondPlaceId != -1
								thirdPlaceId = secondPlaceId
								thirdPlacePoints = secondPlacePoints
								thirdPlaceVotedType = secondPlaceVotedType
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							else
								secondPlaceId = student.id
								secondPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
								secondPlaceVotedType = "teacher"
							end
						elsif Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum > thirdPlacePoints
							thirdPlaceId = student.id
							thirdPlacePoints = Vote.where(:voted_id => student.id, :category_id => params[:category_id]).pluck(:rating).sum
							thirdPlaceVotedType = "teacher"
						end
					end

					@categoryResults[0] = []
					@categoryResults[0][0] = firstPlaceId
					@categoryResults[0][1] = firstPlacePoints
					@categoryResults[0][2] = firstPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[0][3] = firstPlaceVotedType
					@categoryResults[1] = []
					@categoryResults[1][0] = secondPlaceId
					@categoryResults[1][1] = secondPlacePoints
					@categoryResults[1][2] = secondPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[1][3] = secondPlaceVotedType
					@categoryResults[2] = []
					@categoryResults[2][0] = thirdPlaceId
					@categoryResults[2][1] = thirdPlacePoints
					@categoryResults[2][2] = thirdPlacePoints.to_f / @totalPoints.to_f
					@categoryResults[2][3] = thirdPlaceVotedType
					@categoryResults[3] = []
					@categoryResults[3][0] = 100 - ((@categoryResults[0][2]+@categoryResults[1][2]+@categoryResults[2][2])*100)
					@categoryResults[3][1] = @totalPoints-(firstPlacePoints+secondPlacePoints+thirdPlacePoints)
				end		
			else
				@categoryResults[0] = []
				@categoryResults[0][0] = 0
				@categoryResults[0][1] = 0
				@categoryResults[0][2] = 0
				@categoryResults[0][3] = firstPlaceVotedType
				@categoryResults[1] = []
				@categoryResults[1][0] = 0
				@categoryResults[1][1] = 0
				@categoryResults[1][2] = 0
				@categoryResults[1][3] = secondPlaceVotedType
				@categoryResults[2] = []
				@categoryResults[2][0] = 0
				@categoryResults[2][1] = 0
				@categoryResults[2][2] = 0
				@categoryResults[2][3] = thirdPlaceVotedType
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
			@categoryResults[0][3] = firstPlaceVotedType
			@categoryResults[1] = []
			@categoryResults[1][0] = 0
			@categoryResults[1][1] = 0
			@categoryResults[1][2] = 0
			@categoryResults[1][3] = secondPlaceVotedType
			@categoryResults[2] = []
			@categoryResults[2][0] = 0
			@categoryResults[2][1] = 0
			@categoryResults[2][2] = 0
			@categoryResults[2][3] = thirdPlaceVotedType
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

	def list
		@groupset = [[Group.everyone, Group.all_female, Group.all_male], [Group.all_students, Group.female_students, Group.male_students], [Group.all_teachers, Group.female_teachers, Group.male_teachers]]
		return

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
		votedIsAllowedForCategory = true
		isAlreadyVotedFor = false
		@category = Category.find_by_id(params[:category_id])
		redirect_to(give_vote_path(category_id: @category.id), notice: "Die Kategorie wurde nicht gefunden!") and return unless @category
		
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
			if @category.group.male && @category.group.female

			else
				if Student.find_by name: params[:candidate]
					if @category.group.male != voted.male || @category.group.female != voted.female || !@category.group.student
						votedIsAllowedForCategory = false
					end
				elsif Teacher.find_by name: params[:candidate]
					if @category.group.male != voted.male || @category.group.female != voted.female || !@category.group.teacher
						votedIsAllowedForCategory = false
					end
				end
			end

			# breche ab wenn das rating zu hoch/niedrig ist
			redirect_to(give_vote_path(category_id: @category.id), notice: "Rating (" + params[:rating] + ") zu hoch/niedrig!") and return unless (1..3).include?(params[:rating].to_i)

			#breche ab, wenn man für diese Person in dieser Kategorie nicht voten darf
			if votedIsAllowedForCategory
				#fahre nur fort, wenn man noch nicht in dieser kategorie für den gevoteten abgestimmt hat
				if !isAlreadyVotedFor
					#fahre nur fort, wenn gevoteter nicht man selbst ist
					if Student.find_by_name voted.name && voted.id == @current_user.id
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
				redirect_to give_vote_path(category_id: @category.id), notice: "Du darfst in dieser Kategorie nicht für diese Person voten"
			end
		else
			# breche ab wenn kein kandidat gefunden wurde
			redirect_to give_vote_path(category_id: @category.id), notice: "Der Kandidat " + params[:candidate] + " wurde nicht gefunden!"
		end
	end

	def display_error(options = {})
		@message = options[:message]
		@route_back = options[:route_back]
		render :error_while_voting
	end

end