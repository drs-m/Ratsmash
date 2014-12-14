class UserGroup < ActiveRecord::Base

    has_many :memberships, dependent: :destroy, foreign_key: "group_id"
    has_many :members, through: :memberships

    def permissions
        permission_set = {
<<<<<<< HEAD
            "Abizeitung" => [ "categories.*" ],
            "Abimotto" => [ "polls.*" ],
=======
            "Abizeitung" => [
                    "students.index",
                    "students.show",
                    "categories.*",
                    "settings.menu"
                ],
            "Abimotto" => [ "polls.manage.abimotto" ],
>>>>>>> 28ffbc00b40f148e0bf2ba6c2dba1655507ee851
            "Ratsmash-Team" => [ "*" ]
        }

        return permission_set[self.name]
    end

end
