class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.date :date
      t.float :amount
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
