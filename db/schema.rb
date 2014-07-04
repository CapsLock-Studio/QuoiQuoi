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

ActiveRecord::Schema.define(version: 20140704051659) do

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

  create_table "area_translates", force: true do |t|
    t.integer  "locale_id"
    t.integer  "area_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "area_translates", ["area_id"], name: "index_area_translates_on_area_id", using: :btree
  add_index "area_translates", ["locale_id"], name: "index_area_translates_on_locale_id", using: :btree

  create_table "areas", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "locale_id"
  end

  add_index "areas", ["locale_id"], name: "index_areas_on_locale_id", using: :btree

  create_table "article_images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id"
  end

  add_index "article_images", ["article_id"], name: "index_article_images_on_article_id", using: :btree

  create_table "article_type_translates", force: true do |t|
    t.integer  "article_type_id"
    t.integer  "locale_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_type_translates", ["article_type_id"], name: "index_article_type_translates_on_article_type_id", using: :btree
  add_index "article_type_translates", ["locale_id"], name: "index_article_type_translates_on_locale_id", using: :btree

  create_table "article_types", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "locale_id"
  end

  add_index "article_types", ["locale_id"], name: "index_article_types_on_locale_id", using: :btree

  create_table "articles", force: true do |t|
    t.integer  "article_type_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["article_type_id"], name: "index_articles_on_article_type_id", using: :btree

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

  create_table "commemts", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "messsage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_slides", force: true do |t|
    t.integer  "sort"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "youtube"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_translates", force: true do |t|
    t.integer  "contact_id"
    t.integer  "locale_id"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "business_hour"
    t.string   "address"
    t.text     "introduction"
  end

  add_index "contact_translates", ["contact_id"], name: "index_contact_translates_on_contact_id", using: :btree
  add_index "contact_translates", ["locale_id"], name: "index_contact_translates_on_locale_id", using: :btree

  create_table "contact_us", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "course_options", force: true do |t|
    t.integer  "course_id"
    t.integer  "locale_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_options", ["course_id"], name: "index_course_options_on_course_id", using: :btree
  add_index "course_options", ["locale_id"], name: "index_course_options_on_locale_id", using: :btree

  create_table "course_translates", force: true do |t|
    t.integer  "course_id"
    t.integer  "locale_id"
    t.string   "name"
    t.string   "teacher"
    t.text     "description"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
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
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "course"
    t.float    "length"
    t.integer  "popular"
    t.integer  "attendance"
    t.boolean  "canceled",           default: false
    t.datetime "canceled_time"
    t.boolean  "closed",             default: false
    t.datetime "closed_time"
  end

  create_table "designer_translates", force: true do |t|
    t.integer  "designer_id"
    t.string   "name"
    t.string   "introduction"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "message"
    t.string   "position"
  end

  add_index "designer_translates", ["designer_id"], name: "index_designer_translates_on_designer_id", using: :btree
  add_index "designer_translates", ["locale_id"], name: "index_designer_translates_on_locale_id", using: :btree

  create_table "designers", force: true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "google_plus"
    t.string   "linkedin"
  end

  create_table "gift_translates", force: true do |t|
    t.integer  "gift_id"
    t.integer  "locale_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.float    "quota"
  end

  add_index "gift_translates", ["gift_id"], name: "index_gift_translates_on_gift_id", using: :btree
  add_index "gift_translates", ["locale_id"], name: "index_gift_translates_on_locale_id", using: :btree

  create_table "gifts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "instruction_images", force: true do |t|
    t.integer  "instruction_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instruction_images", ["instruction_id"], name: "index_instruction_images_on_instruction_id", using: :btree

  create_table "instructions", force: true do |t|
    t.integer  "locale_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "instructions", ["locale_id"], name: "index_instructions_on_locale_id", using: :btree

  create_table "introduce_image_slides", force: true do |t|
    t.integer  "sort"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "introduce_youtubes", force: true do |t|
    t.integer  "sort"
    t.string   "youtube"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locales", force: true do |t|
    t.string   "lang"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "currency_code"
    t.string   "money_name"
    t.string   "currency"
  end

  create_table "material_translates", force: true do |t|
    t.string   "name"
    t.integer  "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
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

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.boolean  "admin",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",       default: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

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

  create_table "order_custom_item_materials", force: true do |t|
    t.integer  "order_custom_item_id"
    t.integer  "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_custom_item_materials", ["material_id"], name: "index_order_custom_item_materials_on_material_id", using: :btree
  add_index "order_custom_item_materials", ["order_custom_item_id"], name: "index_order_custom_item_materials_on_order_custom_item_id", using: :btree

  create_table "order_custom_item_product_custom_items", force: true do |t|
    t.integer  "order_custom_item_id"
    t.integer  "product_custom_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_custom_item_product_custom_items", ["order_custom_item_id"], name: "order_custom_item_on_product_custom_item", using: :btree
  add_index "order_custom_item_product_custom_items", ["product_custom_item_id"], name: "product_custom_item_order_custom_item", using: :btree

  create_table "order_custom_item_translates", force: true do |t|
    t.integer  "order_custom_item_id"
    t.integer  "locale_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_custom_item_translates", ["locale_id"], name: "index_order_custom_item_translates_on_locale_id", using: :btree
  add_index "order_custom_item_translates", ["order_custom_item_id"], name: "index_order_custom_item_translates_on_order_custom_item_id", using: :btree

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
    t.boolean  "accept"
    t.string   "name"
    t.string   "phone"
    t.string   "line"
    t.datetime "estimate_complete_time"
    t.datetime "accept_time"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "canceled",               default: false
    t.datetime "canceled_time"
    t.integer  "user_id"
    t.string   "currency"
    t.integer  "locale_id"
  end

  add_index "order_custom_items", ["material_id"], name: "index_order_custom_items_on_material_id", using: :btree
  add_index "order_custom_items", ["order_id"], name: "index_order_custom_items_on_order_id", using: :btree
  add_index "order_custom_items", ["product_id"], name: "index_order_custom_items_on_product_id", using: :btree

  create_table "order_informations", force: true do |t|
    t.string   "bag_type"
    t.text     "reference"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
  end

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
    t.boolean  "closed",          default: false
    t.boolean  "delivered",       default: false
    t.boolean  "checkout",        default: false
    t.string   "name"
    t.string   "address"
    t.integer  "zip_code"
    t.string   "phone"
    t.datetime "checkout_time"
    t.datetime "closed_time"
    t.datetime "delivered_time"
    t.boolean  "canceled",        default: false
    t.datetime "canceled_time"
    t.integer  "shipping_fee_id"
    t.string   "currency"
    t.integer  "locale_id"
  end

  add_index "orders", ["shipping_fee_id"], name: "index_orders_on_shipping_fee_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "amount",          default: 0
    t.string   "token"
    t.string   "identifier"
    t.integer  "user_id"
    t.string   "payer_id"
    t.boolean  "completed",       default: false
    t.boolean  "canceled",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.integer  "registration_id"
    t.datetime "pay_time"
    t.boolean  "wait"
    t.integer  "user_gift_id"
    t.string   "currency"
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "product_custom_item_translates", force: true do |t|
    t.integer  "product_custom_item_id"
    t.integer  "locale_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_custom_item_translates", ["locale_id"], name: "index_product_custom_item_translates_on_locale_id", using: :btree
  add_index "product_custom_item_translates", ["product_custom_item_id"], name: "index_product_custom_item_translates_on_product_custom_item_id", using: :btree

  create_table "product_custom_items", force: true do |t|
    t.integer  "product_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.float    "price"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed",           default: false
    t.datetime "closed_time"
    t.string   "name"
    t.string   "phone"
    t.integer  "attendance",       default: 0
    t.integer  "subtotal",         default: 0
    t.boolean  "returned",         default: false
    t.datetime "returned_time"
    t.boolean  "canceled",         default: false
    t.datetime "canceled_time"
    t.string   "email"
    t.text     "reason"
    t.string   "currency"
    t.integer  "locale_id"
    t.integer  "course_option_id"
  end

  add_index "registrations", ["course_id"], name: "index_registrations_on_course_id", using: :btree
  add_index "registrations", ["course_option_id"], name: "index_registrations_on_course_option_id", using: :btree
  add_index "registrations", ["user_id"], name: "index_registrations_on_user_id", using: :btree

  create_table "remittance_translates", force: true do |t|
    t.integer  "locale_id"
    t.string   "name"
    t.string   "account"
    t.string   "bank_name"
    t.string   "bank_address"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "remittance_id"
  end

  add_index "remittance_translates", ["locale_id"], name: "index_remittance_translates_on_locale_id", using: :btree
  add_index "remittance_translates", ["remittance_id"], name: "index remittance_trnaslates on remittance_id", using: :btree

  create_table "remittances", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_contact_translates", force: true do |t|
    t.integer  "rent_contact_id"
    t.integer  "locale_id"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rent_contact_translates", ["locale_id"], name: "index_rent_contact_translates_on_locale_id", using: :btree
  add_index "rent_contact_translates", ["rent_contact_id"], name: "index_rent_contact_translates_on_rent_contact_id", using: :btree

  create_table "rent_contacts", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_info_images", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_info_translates", force: true do |t|
    t.integer  "rent_info_id"
    t.integer  "locale_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rent_info_translates", ["locale_id"], name: "index_rent_info_translates_on_locale_id", using: :btree
  add_index "rent_info_translates", ["rent_info_id"], name: "index_rent_info_translates_on_rent_info_id", using: :btree

  create_table "rent_infos", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_intro_translates", force: true do |t|
    t.integer  "rent_intro_id"
    t.integer  "locale_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rent_intro_translates", ["locale_id"], name: "index_rent_intro_translates_on_locale_id", using: :btree
  add_index "rent_intro_translates", ["rent_intro_id"], name: "index_rent_intro_translates_on_rent_intro_id", using: :btree

  create_table "rent_intros", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirement_intro_translates", force: true do |t|
    t.integer  "requirement_intro_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "title"
  end

  add_index "requirement_intro_translates", ["locale_id"], name: "index_requirement_intro_translates_on_locale_id", using: :btree
  add_index "requirement_intro_translates", ["requirement_intro_id"], name: "index_requirement_intro_translates_on_requirement_intro_id", using: :btree

  create_table "requirement_intros", force: true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirement_translates", force: true do |t|
    t.integer  "requirement_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "title"
  end

  add_index "requirement_translates", ["locale_id"], name: "index_requirement_translates_on_locale_id", using: :btree
  add_index "requirement_translates", ["requirement_id"], name: "index_requirement_translates_on_requirement_id", using: :btree

  create_table "requirements", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shipping_fee_translates", force: true do |t|
    t.integer  "locale_id"
    t.integer  "shipping_fee_id"
    t.float    "fee"
    t.float    "free_condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shipping_fee_translates", ["locale_id"], name: "index_shipping_fee_translates_on_locale_id", using: :btree
  add_index "shipping_fee_translates", ["shipping_fee_id"], name: "index_shipping_fee_translates_on_shipping_fee_id", using: :btree

  create_table "shipping_fees", force: true do |t|
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "top_products", force: true do |t|
    t.integer  "product_id"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "top_products", ["product_id"], name: "index_top_products_on_product_id", using: :btree

  create_table "travel_informations", force: true do |t|
    t.integer  "area_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "travel_informations", ["area_id"], name: "index_travel_informations_on_area_id", using: :btree

  create_table "travel_photos", force: true do |t|
    t.integer  "travel_information_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "travel_photos", ["travel_information_id"], name: "index_travel_photos_on_travel_information_id", using: :btree

  create_table "user_gifts", force: true do |t|
    t.integer  "user_id"
    t.integer  "gift_id"
    t.string   "token"
    t.integer  "used_user_id"
    t.datetime "used_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
    t.integer  "locale_id"
  end

  add_index "user_gifts", ["gift_id"], name: "index_user_gifts_on_gift_id", using: :btree
  add_index "user_gifts", ["user_id"], name: "index_user_gifts_on_user_id", using: :btree

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
    t.string   "phone"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
