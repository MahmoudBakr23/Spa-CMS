class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.references :client, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.references :trainer, null: false, foreign_key: true
      t.datetime :perform_at
      t.string :status

      t.text :notes

      t.timestamps
    end
  end
end
