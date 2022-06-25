class AddSwitchDateToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :switch_date, :string
  end
end
