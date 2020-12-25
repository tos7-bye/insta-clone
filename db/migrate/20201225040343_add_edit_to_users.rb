class AddEditToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone_number, :integer
    add_column :users, :introduction, :text
    add_column :users, :web_site, :string
  end
end
