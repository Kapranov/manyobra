class CreateBlogComments < ActiveRecord::Migration
  def change
    create_table :blog_comments do |t|
      t.string :author
      t.text :content
      t.references :post, index: true

      t.timestamps
    end
  end
end
