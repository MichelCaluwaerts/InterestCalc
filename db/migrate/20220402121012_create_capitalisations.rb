class CreateCapitalisations < ActiveRecord::Migration[6.0]
  def change
    create_table :capitalisations do |t|
      t.date :date
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
