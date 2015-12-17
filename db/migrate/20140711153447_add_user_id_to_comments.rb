class AddUserIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :string
    add_column :comments, :parent, :string
    add_column :comments, :approved, :string
    add_column :comments, :browser_agent, :string
  end
end
