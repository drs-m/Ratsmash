class Membership < ActiveRecord::Base

    belongs_to :member, class_name: "Student"
    belongs_to :group, class_name: "UserGroup"

end
