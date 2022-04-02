class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.date :date
      t.date :date_fin
      t.float :pct
      t.string :int_type

      t.timestamps
    end
  end
end
