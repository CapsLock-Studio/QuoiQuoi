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

ActiveRecord::Schema.define(version: 20140407141115) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "broadcast_translates", force: true do |t|
    t.integer  "broadcast_id"
    t.string   "notification"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
  end

  add_index "broadcast_translates", ["broadcast_id"], name: "index_broadcast_translates_on_broadcast_id", using: :btree

  create_table "broadcasts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort"
    t.string   "link"
  end

  create_table "course_images", force: true do |t|
    t.integer  "course_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_images", ["course_id"], name: "index_course_images_on_course_id", using: :btree

  create_table "course_translates", force: true do |t|
    t.integer  "course_id"
    t.integer  "locale_id"
    t.string   "name"
    t.string   "teacher"
    t.string   "description"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_translates", ["course_id"], name: "index_course_translates_on_course_id", using: :btree
  add_index "course_translates", ["locale_id"], name: "index_course_translates_on_locale_id", using: :btree

  create_table "course_type_translates", force: true do |t|
    t.integer  "locale_id"
    t.integer  "course_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_type_translates", ["course_type_id"], name: "index_course_type_translates_on_course_type_id", using: :btree
  add_index "course_type_translates", ["locale_id"], name: "index_course_type_translates_on_locale_id", using: :btree

  create_table "course_types", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: true do |t|
    t.integer  "price"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "course"
    t.float    "length"
  end

  create_table "locales", force: true do |t|
    t.string   "lang"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "material_translates", force: true do |t|
    t.string   "name"
    t.integer  "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "material_translates", ["material_id"], name: "index_material_translates_on_material_id", using: :btree

  create_table "materials", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "models", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "models", ["email"], name: "index_models_on_email", unique: true, using: :btree
  add_index "models", ["reset_password_token"], name: "index_models_on_reset_password_token", unique: true, using: :btree

  create_table "order_custom_item_images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "order_custom_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_custom_item_images", ["order_custom_item_id"], name: "index_order_custom_item_images_on_order_custom_item_id", using: :btree

  create_table "order_custom_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "design"
    t.string   "style"
    t.integer  "material_id"
    t.string   "description"
    t.string   "response"
    t.integer  "workday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
    t.boolean  "accept"
  end

  add_index "order_custom_items", ["material_id"], name: "index_order_custom_items_on_material_id", using: :btree
  add_index "order_custom_items", ["order_id"], name: "index_order_custom_items_on_order_id", using: :btree
  add_index "order_custom_items", ["product_id"], name: "index_order_custom_items_on_product_id", using: :btree

  create_table "order_product_custom_items", force: true do |t|
    t.integer  "order_product_id"
    t.integer  "product_custom_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_product_custom_items", ["order_product_id"], name: "index_order_product_custom_items_on_order_product_id", using: :btree
  add_index "order_product_custom_items", ["product_custom_item_id"], name: "index_order_product_custom_items_on_product_custom_item_id", using: :btree

  create_table "order_products", force: true do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_products", ["order_id"], name: "index_order_products_on_order_id", using: :btree
  add_index "order_products", ["product_id"], name: "index_order_products_on_product_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "subtotal"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed"
    t.boolean  "verified"
    t.integer  "paid"
    t.datetime "paid_time"
    t.boolean  "delivered"
    t.boolean  "checkout"
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "product_custom_item_translates", force: true do |t|
    t.integer  "locale_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_custom_item_id"
  end

  add_index "product_custom_item_translates", ["locale_id"], name: "index_product_custom_item_translates_on_locale_id", using: :btree
  add_index "product_custom_item_translates", ["product_custom_item_id"], name: "index_product_custom_item_translates_on_product_custom_item_id", using: :btree

  create_table "product_custom_items", force: true do |t|
    t.integer  "product_id"
    t.integer  "product_custom_type_id"
    t.integer  "price"
    t.integer  "workday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "product_custom_items", ["product_custom_type_id"], name: "index_product_custom_items_on_product_custom_type_id", using: :btree
  add_index "product_custom_items", ["product_id"], name: "index_product_custom_items_on_product_id", using: :btree

  create_table "product_custom_type_translates", force: true do |t|
    t.integer  "locale_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_custom_type_id"
  end

  add_index "product_custom_type_translates", ["locale_id"], name: "index_product_custom_type_translates_on_locale_id", using: :btree
  add_index "product_custom_type_translates", ["product_custom_type_id"], name: "index_product_custom_type_translates_on_product_custom_type_id", using: :btree

  create_table "product_custom_types", force: true do |t|
    t.boolean  "multi"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_images", force: true do |t|
    t.integer  "product_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_images", ["product_id"], name: "index_product_images_on_product_id", using: :btree

  create_table "product_translates", force: true do |t|
    t.integer  "locale_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
  end

  add_index "product_translates", ["locale_id"], name: "index_product_translates_on_locale_id", using: :btree
  add_index "product_translates", ["product_id"], name: "index_product_translates_on_product_id", using: :btree

  create_table "product_type_translates", force: true do |t|
    t.string   "name"
    t.integer  "product_type_id"
    t.integer  "locale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_youtubes", force: true do |t|
    t.integer  "product_id"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_youtubes", ["product_id"], name: "index_product_youtubes_on_product_id", using: :btree

  create_table "products", force: true do |t|
    t.integer  "price"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "registrations", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.boolean  "accept"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registrations", ["course_id"], name: "index_registrations_on_course_id", using: :btree
  add_index "registrations", ["user_id"], name: "index_registrations_on_user_id", using: :btree

  create_table "ships", force: true do |t|
    t.integer  "order_id"
    t.integer  "paid"
    t.boolean  "delivered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed"
  end

  add_index "ships", ["order_id"], name: "index_ships_on_order_id", using: :btree

  create_table "slide_positions", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slide_translates", force: true do |t|
    t.integer  "locale_id"
    t.integer  "slide_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slide_translates", ["locale_id"], name: "index_slide_translates_on_locale_id", using: :btree
  add_index "slide_translates", ["slide_id"], name: "index_slide_translates_on_slide_id", using: :btree

  create_table "slides", force: true do |t|
    t.integer  "sort"
    t.string   "link"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "slide_position_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "name"
    t.integer  "zip_code"
    t.string   "address"
    t.string   "line"
    t.integer  "phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
