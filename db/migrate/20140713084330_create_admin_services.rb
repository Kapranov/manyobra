class CreateAdminServices < ActiveRecord::Migration
  def change
    create_table :admin_services do |t|
      t.string :name
      t.string :description
      t.decimal :price, precision: 7, scale: 2

      t.timestamps
    end
  end
end
