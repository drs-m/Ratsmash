class RenameMemberShipGroupId < ActiveRecord::Migration
  def change
      change_table :memberships do |t|
          t.rename :group_id, :user_group_id
      end
  end
end
