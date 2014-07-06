class RenameIDsInDescriptions < ActiveRecord::Migration
  def change
    change_table :descriptions do |t|
        t.rename :from_id, :author_id
        t.rename :for_id, :described_id
    end
  end
end
