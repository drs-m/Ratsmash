class UserGroup < ActiveRecord::Base

    has_many :memberships, dependent: :destroy, foreign_key: "group_id"
    has_many :members, through: :memberships

    def permissions
        permission_set = {
            "Abizeitung" => [ "categories.*" ],
            "Abimotto" => [ "polls.*" ],
            "Ratsmash-Team" => [ "*" ]
        }

        return permission_set[self.name]
    end

end
