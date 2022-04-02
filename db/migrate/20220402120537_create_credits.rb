class CreateCredits < ActiveRecord::Migration[6.0]
  def change
    create_table :credits do |t|
      t.string :description
      t.date :date
      t.float :amount
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
