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
                third_most_logins[2] = second_most_logins[2]
                third_most_logins[3] = second_most_logins[3]
                second_most_logins[0] = most_logins[0]
                second_most_logins[1] = most_logins[1]
                second_most_logins[2] = most_logins[2]
                second_most_logins[3] = most_logins[3]

                most_logins[0] = student.name
                most_logins[1] = Login.where(:user_id=>student.id).count
                most_logins[2] = Login.where(:user_id=>student.id,:mobile_device => true).count
                most_logins[3] = Login.where(:user_id=>student.id,:mobile_device => false).count
            else
                if Login.where(:user_id=>student.id).count > second_most_logins[1]
                    third_most_logins[0] = second_most_logins[0]
                    third_most_logins[1] = second_most_logins[1]
                    third_most_logins[2] = second_most_logins[2]
                    third_most_logins[3] = second_most_logins[3]
                    
                    second_most_logins[0] = student.name
                    second_most_logins[1] = Login.where(:user_id=>student.id).count
                    second_most_logins[2] = Login.where(:user_id=>student.id, :mobile_device => true).count
                    second_most_logins[3] = Login.where(:user_id=>student.id, :mobile_device => false).count
                else
                    if Login.where(:user_id=>student.id).count > third_most_logins[1]
                        third_most_logins[0] = student.name
                        third_most_logins[1] = Login.where(:user_id=>student.id).count
                        third_most_logins[2] = Login.where(:user_id=>student.id, :mobile_device => true).count
                        third_most_logins[3] = Login.where(:user_id=>student.id, :mobile_device => false).count
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
                flash[:error] = "User nicht vorhanden!"
            end
        end

    	@now_online_students = Student.online

    	@total_logins = Login.count

        @mobile_device_logins = Login.where(:mobile_device => true).count.to_f
        @desktop_device_logins = Login.where(:mobile_device => false).count.to_f

        @desktop_login_percentage = 0.0
        if Login.count > 0
            @desktop_login_percentage = (@desktop_device_logins / Login.count.to_f) * 100
            @desktop_login_percentage = @desktop_login_percentage.round(2)
        end
        @mobile_login_percentage = 0.0
        if Login.count > 0
            @mobile_login_percentage = (@mobile_device_logins / Login.count.to_f) * 100
            @mobile_login_percentage = @mobile_login_percentage.round(2)
        end

        @logins_in_last = {hour: Login.last_hour.count, day: Login.last_day.count, week: Login.last_week.count, month: Login.last_month.count}
        
        @last_10_logins = Login.order(created_at: :desc).limit(10)
        
    end

end
