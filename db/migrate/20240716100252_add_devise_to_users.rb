# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def self.up
    change_table :users do |t|
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    change_column_null :users, :email, false
    change_column_null :users, :encrypted_password, false

    change_column_default :users, :email, ""
    change_column_default :users, :encrypted_password, ""

  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
