class CreateCases < ActiveRecord::Migration[7.2]
  def change
    create_table :cases do |t|
      t.string :case_number
      t.string :title
      t.string :description
      t.integer :status, default: 0
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :assigned_to, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
