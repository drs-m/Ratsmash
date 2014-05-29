class AddPasswordResetToStudents < ActiveRecord::Migration
  def change
    add_column :students, :passwort_reset_token, :string
    add_column :students, :password_reset_sent_at, :datetime
  end
end
