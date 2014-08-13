class AddMobileDeviceToLogin < ActiveRecord::Migration
  def change
  	add_column :logins, :mobile_device, :boolean
  end
end
