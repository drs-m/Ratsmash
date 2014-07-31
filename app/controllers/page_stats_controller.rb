class PageStatsController < ApplicationController

	before_action -> { check_session redirect: true, admin_permissions: true }

    def index
        if params[:name]
            if Student.find_by_name params[:name]
                student = Student.find_by_name params[:name]
                @students_logins_name = student.name
                @students_logins = Login.where :user_id => student.id
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
