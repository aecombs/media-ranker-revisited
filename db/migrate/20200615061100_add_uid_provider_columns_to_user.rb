class AddUidProviderColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :avatar, :string
    add_column :users, :email, :string
  end
end
