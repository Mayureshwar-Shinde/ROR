class CreateCommunications < ActiveRecord::Migration[7.1]
  def change
    create_table :communications do |t|
      t.references :from, null: false, foreign_key: { to_table: :users }
      t.references :to, null: false, foreign_key: { to_table: :users }
      t.string :subject
      t.string :message
      t.string :message_type
      t.references :case, null: false, foreign_key: { to_table: :cases }

      t.timestamps
    end
  end
end
