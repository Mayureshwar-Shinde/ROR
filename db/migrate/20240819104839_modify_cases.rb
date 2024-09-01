class ModifyCases < ActiveRecord::Migration[7.1]
  def up
    remove_column :cases, :resolved_by_id
    remove_column :cases, :resolved_at
  end

  def down
  end
end
