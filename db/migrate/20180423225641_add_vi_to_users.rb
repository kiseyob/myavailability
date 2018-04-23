class AddViToUsers < ActiveRecord::Migration
  def change
    add_column :users, :iv, :string
  end
end
