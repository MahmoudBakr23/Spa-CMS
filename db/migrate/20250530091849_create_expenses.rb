class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.decimal :amount
      t.date :occurred_on
      t.string :category
      t.text :notes

      t.timestamps
    end
  end
end
