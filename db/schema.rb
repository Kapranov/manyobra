# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141121182403) do

  create_table "admin_services", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price",       precision: 7, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_categorizings", force: true do |t|
    t.integer  "category_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_categorizings", ["category_id"], name: "index_blog_categorizings_on_category_id", using: :btree
  add_index "blog_categorizings", ["post_id"], name: "index_blog_categorizings_on_post_id", using: :btree

  create_table "blog_comments", force: true do |t|
    t.string   "author"
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_comments", ["post_id"], name: "index_blog_comments_on_post_id", using: :btree

  create_table "blog_posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "slug"
    t.string   "author"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_taggings", ["post_id"], name: "index_blog_taggings_on_post_id", using: :btree
  add_index "blog_taggings", ["tag_id"], name: "index_blog_taggings_on_tag_id", using: :btree

  create_table "blog_tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizings", force: true do |t|
    t.integer  "category_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categorizings", ["category_id"], name: "index_categorizings_on_category_id", using: :btree
  add_index "categorizings", ["post_id"], name: "index_categorizings_on_post_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "post_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "author"
    t.string   "email"
    t.string   "user_id"
    t.string   "parent"
    t.string   "approved"
    t.string   "browser_agent"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "subject"
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "author"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "twitter_name", limit: 50
    t.string   "github_name",  limit: 50
    t.text     "bio"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "services", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "price",       precision: 7, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["post_id"], name: "index_taggings_on_post_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "description"
  end

  create_table "users", force: true do |t|
    t.string   "email",                        limit: 70
    t.string   "first_name",                   limit: 50
    t.string   "last_name",                    limit: 50
    t.string   "password_digest"
    t.datetime "created_at",                                                                       null: false
    t.datetime "updated_at",                                                                       null: false
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "subscribed_at"
    t.string   "language",                     limit: 10
    t.decimal  "balance",                                 precision: 30, scale: 2, default: 0.0
    t.decimal  "frozen_balance",                          precision: 30, scale: 2, default: 0.0
    t.string   "currency",                                                         default: "UAH"
    t.date     "birthday"
    t.string   "gender",                       limit: 30
    t.string   "country",                      limit: 2
    t.string   "province"
    t.string   "city"
    t.string   "mobile",                       limit: 25
    t.string   "landline",                     limit: 25
    t.string   "verification_pincode_for_sms"
    t.string   "verification",                 limit: 5
    t.string   "time_zone",                                                        default: "UTC"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

end
