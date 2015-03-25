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
                "settings.menu",
                "child_pics.index",
                "child_pics.show"
            ],
            "Abimotto" => [ "poll.abimotto" ],
            "Ratsmash-Team" => [ "*" ],
            "Spectator" => [ "settings.menu", "voting.results" ]
        }

        return permission_set[self.name]
    end

end
