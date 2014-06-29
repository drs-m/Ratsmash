class DropTable < ActiveRecord::Migration
  def up
    drop_table :go_lives
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
