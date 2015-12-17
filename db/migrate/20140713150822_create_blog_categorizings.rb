class CreateBlogCategorizings < ActiveRecord::Migration
  def change
    create_table :blog_categorizings do |t|
      t.references :category, index: true
      t.references :post, index: true

      t.timestamps
    end
  end
end
