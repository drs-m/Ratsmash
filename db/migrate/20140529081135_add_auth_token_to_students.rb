class AddAuthTokenToStudents < ActiveRecord::Migration
  def change
    add_column :students, :auth_token, :string
  end
end
