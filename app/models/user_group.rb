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
                "child_pics.show",
                "child_pics.download",
                "descriptions.list-all",
                "quotes.index",
                "quotes.list-all",
                "descriptions.show-all",
                "class_trips.index",
                "class_trips.show"
            ],
            "Abimotto" => [ "poll.abimotto" ],
            "Ratsmash-Team" => [ "*" ],
            "Spectator" => [ "settings.menu", "voting.results" ]
        }

        return permission_set[self.name]
    end

end
