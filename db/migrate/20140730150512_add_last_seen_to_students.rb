class AddLastSeenToStudents < ActiveRecord::Migration
  def change
  	add_column :students, :last_seen_at, :datetime
  end
end
