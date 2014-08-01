class PageStatsController < ApplicationController

	before_action -> { check_session redirect: true, admin_permissions: true }

    def index
        most_logins = ["keiner",0]
        second_most_logins = ["keiner",0]
        third_most_logins = ["keiner",0]

        Student.all.each do |student|
            if Login.where(:user_id=>student.id).count > most_logins[1]
                third_most_logins[0] = second_most_logins[0]
                third_most_logins[1] = second_most_logins[1]
                second_most_logins[0] = most_logins[0]
                second_most_logins[1] = most_logins[1]

                most_logins[0] = student.name
                most_logins[1] = Login.where(:user_id=>student.id).count
            else
                if Login.where(:user_id=>student.id).count > second_most_logins[1]
                    third_most_logins[0] = second_most_logins[0]
                    third_most_logins[1] = second_most_logins[1]
                    
                    second_most_logins[0] = student.name
                    second_most_logins[1] = Login.where(:user_id=>student.id).count
                else
                    if Login.where(:user_id=>student.id).count > third_most_logins[1]
                        third_most_logins[0] = student.name
                        third_most_logins[1] = Login.where(:user_id=>student.id).count
                    end
                end
            end
        end

        @login_ranking = []
        @login_ranking[0] = most_logins
        @login_ranking[1] = second_most_logins
        @login_ranking[2] = third_most_logins

        if params[:name]
            if Student.find_by_name params[:name]
                student = Student.find_by_name params[:name]
                @students_logins_name = student.name
                @students_logins = Login.where :user_id => student.id
                @students_logins = @students_logins.reverse
            else
                flash[:notice] = "User nicht vorhanden!"
            end
        end

    	@now_online_students = []

    	Student.all.each do |student|
    		if student.online?
    			@now_online_students << student
    		end
    	end

    	@total_logins = Login.all.count

    	@logins_sice_last_hour = 0

    	Login.all.each do |login|
    		if login.created_at > 1.hours.ago
    			@logins_sice_last_hour += 1
    		end
    	end

    	@logins_sice_last_24_hours = 0

    	Login.all.each do |login|
    		if login.created_at > 24.hours.ago
    			@logins_sice_last_24_hours += 1
    		end
    	end

    	@logins_sice_last_week = 0

    	Login.all.each do |login|
    		if login.created_at > 1.weeks.ago
    			@logins_sice_last_week += 1
    		end
    	end

    	@logins_sice_last_month = 0

    	Login.all.each do |login|
    		if login.created_at > 1.months.ago
    			@logins_sice_last_month += 1
    		end
    	end
    end

end
