class AddVerificationTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :verification_token, :string
    add_index  :users, :verification_token
  end
end
