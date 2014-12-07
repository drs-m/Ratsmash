class RenameMembershipFields < ActiveRecord::Migration
  def change
      change_table :memberships do |t|
        t.rename :user_group_id, :group_id
        t.rename :student_id, :member_id
      end
  end
end
