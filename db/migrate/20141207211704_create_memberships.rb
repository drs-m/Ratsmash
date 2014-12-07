class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :student_id
      t.integer :group_id

      t.timestamps
    end
  end
end
