class CreatePeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :periods do |t|
      t.date :date
      t.date :date_fin
      t.references :account, null: false, foreign_key: true
      t.references :rate, null: false, foreign_key: true

      t.timestamps
    end
  end
end
