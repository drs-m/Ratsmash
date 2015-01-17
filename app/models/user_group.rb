class UserGroup < ActiveRecord::Base

    has_many :memberships, dependent: :destroy, foreign_key: "group_id"
    has_many :members, through: :memberships

    def permissions
        permission_set = {
            "Abizeitung" => [
                "students.index",
                "students.show",
                "teachers.*",
                "categories.*",
                "settings.menu"
            ],
            "Abimotto" => [ "polls.manage.abimotto" ],
            "Ratsmash-Team" => [ "*" ]
        }

        return permission_set[self.name]
    end

end
