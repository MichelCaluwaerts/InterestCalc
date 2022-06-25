class AddSwitchDateToRates < ActiveRecord::Migration[6.0]
  def change
    add_column :rates, :switch_date, :string
  end
end
