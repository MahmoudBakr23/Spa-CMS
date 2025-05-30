class CreateRevenues < ActiveRecord::Migration[8.0]
  def change
    create_table :revenues do |t|
      t.references :session, null: false, foreign_key: true
      t.decimal :amount

      t.timestamps
    end
  end
end
