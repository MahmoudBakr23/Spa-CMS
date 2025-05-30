class CreateTrainers < ActiveRecord::Migration[8.0]
  def change
    create_table :trainers do |t|
      t.references :admin_user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone

      t.timestamps
    end
  end
end
