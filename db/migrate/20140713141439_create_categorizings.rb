class CreateCategorizings < ActiveRecord::Migration
  def change
    create_table :categorizings do |t|
      t.references :category, index: true
      t.references :post, index: true

      t.timestamps
    end
  end
end
