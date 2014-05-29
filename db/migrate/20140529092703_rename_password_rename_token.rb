class RenamePasswordRenameToken < ActiveRecord::Migration
  def change
  	change_table :students do |t|
  		t.rename :passwort_reset_token, :password_reset_token
  	end
  end
end
