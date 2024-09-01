class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.date :date
      t.datetime :start_time
      t.datetime :end_time
      t.string :status
      t.references :case, null: false, foreign_key: true
      t.references :scheduler, null: false, foreign_key: { to_table: :users }
      t.references :schedulee, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
