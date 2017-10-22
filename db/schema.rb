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

ActiveRecord::Schema.define(version: 20170826072019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   limit: 255
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "areas", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.integer  "locale_id"
  end

  create_table "article_images", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_id"
  end

  create_table "article_types", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.integer  "locale_id"
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "article_type_id"
    t.string   "title",           limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "broadcast_translates", force: :cascade do |t|
    t.integer  "broadcast_id"
    t.string   "notification", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "link",         limit: 255
  end

  create_table "broadcasts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort"
  end

  create_table "commemts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "messsage",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_translates", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "locale_id"
    t.string   "email",         limit: 255
    t.string   "phone",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "business_hour", limit: 255
    t.string   "address",       limit: 255
    t.text     "introduction"
  end

  create_table "contact_us", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "content",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_addition_images", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_id"], name: "index_course_addition_images_on_course_id", using: :btree
  end

  create_table "course_images", force: :cascade do |t|
    t.integer  "course_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_option_groups", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "locale_id"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_id"], name: "index_course_option_groups_on_course_id", using: :btree
    t.index ["locale_id"], name: "index_course_option_groups_on_locale_id", using: :btree
  end

  create_table "course_options", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "locale_id"
    t.string   "content",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",                              default: 0.0
    t.integer  "course_option_group_id"
    t.index ["course_id"], name: "index_course_options_on_course_id", using: :btree
    t.index ["locale_id"], name: "index_course_options_on_locale_id", using: :btree
  end

  create_table "course_translates", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "locale_id"
    t.string   "name",        limit: 255
    t.string   "teacher",     limit: 255
    t.text     "description"
    t.string   "note",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "course",             limit: 255
    t.float    "length"
    t.integer  "popular"
    t.integer  "attendance"
    t.boolean  "canceled",                       default: false
    t.datetime "canceled_time"
    t.boolean  "full",                           default: false
    t.datetime "full_time"
    t.boolean  "visible",                        default: true
  end

  create_table "custom_orders", force: :cascade do |t|
    t.string   "style"
    t.string   "order_type"
    t.string   "materials"
    t.string   "phone"
    t.string   "email"
    t.string   "line"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "user_id"
    t.float    "price"
    t.boolean  "approve"
    t.integer  "product_id"
    t.datetime "approve_time"
    t.boolean  "cancel",          default: false
    t.text     "cancel_reason"
    t.datetime "cancel_time"
    t.text     "dismiss_message"
    t.integer  "locale_id"
    t.string   "references"
    t.string   "size"
    t.text     "description"
    t.index ["user_id"], name: "index_custom_orders_on_user_id", using: :btree
  end

  create_table "designer_translates", force: :cascade do |t|
    t.integer  "designer_id"
    t.string   "name",         limit: 255
    t.string   "introduction", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "message",      limit: 255
    t.string   "position",     limit: 255
  end

  create_table "designers", force: :cascade do |t|
    t.string   "photo_file_name",     limit: 255
    t.string   "photo_content_type",  limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "facebook",            limit: 255
    t.string   "twitter",             limit: 255
    t.string   "google_plus",         limit: 255
    t.string   "linkedin",            limit: 255
  end

  create_table "faqs", force: :cascade do |t|
    t.integer  "locale_id"
    t.string   "question",   limit: 255
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["locale_id"], name: "index_faqs_on_locale_id", using: :btree
  end

  create_table "gift_translates", force: :cascade do |t|
    t.integer  "gift_id"
    t.integer  "locale_id"
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.float    "quota"
  end

  create_table "gifts", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "visible",                        default: true
  end

  create_table "instruction_images", force: :cascade do |t|
    t.integer  "instruction_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["instruction_id"], name: "index_instruction_images_on_instruction_id", using: :btree
  end

  create_table "instructions", force: :cascade do |t|
    t.integer  "locale_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["locale_id"], name: "index_instructions_on_locale_id", using: :btree
  end

  create_table "introduce_image_slides", force: :cascade do |t|
    t.integer  "sort"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "introduce_youtubes", force: :cascade do |t|
    t.integer  "sort"
    t.string   "youtube",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locales", force: :cascade do |t|
    t.string   "lang",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       limit: 255
    t.string   "currency",   limit: 255
  end

  create_table "material_translates", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
  end

  create_table "material_type_translates", force: :cascade do |t|
    t.integer  "material_type_id"
    t.integer  "locale_id"
    t.string   "name",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["locale_id"], name: "index_material_type_translates_on_locale_id", using: :btree
    t.index ["material_type_id"], name: "index_material_type_translates_on_material_type_id", using: :btree
  end

  create_table "material_types", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",    default: true
    t.boolean  "collapsed",  default: false
    t.boolean  "all",        default: true
  end

  create_table "materials", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",                        default: true
    t.integer  "material_type_id"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.boolean  "admin",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",            default: false
    t.integer  "custom_order_id"
  end

  create_table "models", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_models_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_models_on_reset_password_token", unique: true, using: :btree
  end

  create_table "order_custom_item_images", force: :cascade do |t|
    t.string   "image_file_name",      limit: 255
    t.string   "image_content_type",   limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "order_custom_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_custom_item_materials", force: :cascade do |t|
    t.integer  "order_custom_item_id"
    t.integer  "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_custom_item_product_custom_items", force: :cascade do |t|
    t.integer  "order_custom_item_id"
    t.integer  "product_custom_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["order_custom_item_id"], name: "order_custom_item_on_product_custom_item", using: :btree
    t.index ["product_custom_item_id"], name: "product_custom_item_order_custom_item", using: :btree
  end

  create_table "order_custom_item_translates", force: :cascade do |t|
    t.integer  "order_custom_item_id"
    t.integer  "locale_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["locale_id"], name: "index_order_custom_item_translates_on_locale_id", using: :btree
    t.index ["order_custom_item_id"], name: "index_order_custom_item_translates_on_order_custom_item_id", using: :btree
  end

  create_table "order_custom_items", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.string   "design",                 limit: 255
    t.string   "style",                  limit: 255
    t.string   "description",            limit: 255
    t.string   "response",               limit: 255
    t.integer  "workday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accept"
    t.string   "name",                   limit: 255
    t.string   "phone",                  limit: 255
    t.string   "line",                   limit: 255
    t.datetime "estimate_complete_time"
    t.datetime "accept_time"
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "canceled",                           default: false
    t.datetime "canceled_time"
    t.integer  "user_id"
    t.integer  "locale_id"
    t.integer  "custom_order_id"
  end

  create_table "order_informations", force: :cascade do |t|
    t.string   "bag_type",   limit: 255
    t.text     "reference"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
  end

  create_table "order_payments", force: :cascade do |t|
    t.float    "amount"
    t.string   "token"
    t.string   "bankcode"
    t.string   "account"
    t.datetime "expire_time"
    t.string   "trade_no"
    t.datetime "trade_time"
    t.string   "payment_no"
    t.boolean  "completed"
    t.datetime "completed_time"
    t.string   "redirect_uri"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "order_id"
    t.boolean  "cancel",         default: false
    t.text     "cancel_reason"
    t.datetime "cancel_time"
    t.string   "payer_id"
    t.datetime "payment_time"
    t.index ["order_id"], name: "index_order_payments_on_order_id", using: :btree
  end

  create_table "order_product_options", force: :cascade do |t|
    t.integer  "order_product_id"
    t.integer  "product_option_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["order_product_id"], name: "index_order_product_options_on_order_product_id", using: :btree
    t.index ["product_option_id"], name: "index_order_product_options_on_product_option_id", using: :btree
  end

  create_table "order_products", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",             default: 0.0
    t.float    "discount",          default: 0.0
    t.integer  "product_option_id"
    t.index ["product_option_id"], name: "index_order_products_on_product_option_id", using: :btree
  end

  create_table "order_remittance_reports", force: :cascade do |t|
    t.float    "amount"
    t.string   "account"
    t.datetime "date"
    t.boolean  "confirm"
    t.integer  "order_payment_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "message"
    t.index ["order_payment_id"], name: "index_order_remittance_reports_on_order_payment_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.float    "subtotal"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed",                                   default: false
    t.boolean  "delivered",                                default: false
    t.boolean  "checkout",                                 default: false
    t.string   "name",                         limit: 255
    t.string   "address",                      limit: 255
    t.integer  "zip_code"
    t.string   "phone",                        limit: 255
    t.datetime "checkout_time"
    t.datetime "closed_time"
    t.datetime "delivered_time"
    t.boolean  "canceled",                                 default: false
    t.datetime "canceled_time"
    t.integer  "shipping_fee_id"
    t.string   "currency",                     limit: 255
    t.integer  "locale_id"
    t.integer  "payment_method",                           default: 0
    t.boolean  "delivery_report",                          default: false
    t.datetime "delivery_report_time"
    t.text     "delivery_report_message"
    t.boolean  "delivery_report_handled",                  default: false
    t.datetime "delivery_report_handled_time"
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "past_work_addition_images", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "past_work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["past_work_id"], name: "index_past_work_addition_images_on_past_work_id", using: :btree
  end

  create_table "past_work_images", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "past_work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["past_work_id"], name: "index_past_work_images_on_past_work_id", using: :btree
  end

  create_table "past_work_translates", force: :cascade do |t|
    t.integer  "locale_id"
    t.integer  "past_work_id"
    t.string   "name",         limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "order_type"
    t.string   "style"
    t.string   "size"
    t.string   "materials"
    t.index ["locale_id"], name: "index_past_work_translates_on_locale_id", using: :btree
    t.index ["past_work_id"], name: "index_past_work_translates_on_past_work_id", using: :btree
  end

  create_table "past_work_type_translates", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "description",       limit: 255
    t.integer  "past_work_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.index ["locale_id"], name: "index_past_work_type_translates_on_locale_id", using: :btree
    t.index ["past_work_type_id"], name: "index_past_work_type_translates_on_past_work_type_id", using: :btree
  end

  create_table "past_work_types", force: :cascade do |t|
    t.string   "thumbnail_file_name",    limit: 255
    t.string   "thumbnail_content_type", limit: 255
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "sort"
    t.boolean  "visible",                            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "past_works", force: :cascade do |t|
    t.date     "completion_time"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "visible",                        default: true
    t.integer  "past_work_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["past_work_type_id"], name: "index_past_works_on_past_work_type_id", using: :btree
  end

  create_table "payments", force: :cascade do |t|
    t.float    "amount",                      default: 0.0
    t.string   "token",           limit: 255
    t.string   "identifier",      limit: 255
    t.integer  "user_id"
    t.string   "payer_id",        limit: 255
    t.boolean  "completed",                   default: false
    t.boolean  "canceled",                    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "order_id"
    t.integer  "registration_id"
    t.datetime "pay_time"
    t.boolean  "wait"
    t.integer  "user_gift_id"
    t.string   "currency",        limit: 255
  end

  create_table "product_addition_images", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["product_id"], name: "index_product_addition_images_on_product_id", using: :btree
  end

  create_table "product_custom_item_translates", force: :cascade do |t|
    t.integer  "product_custom_item_id"
    t.integer  "locale_id"
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_custom_items", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_images", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_material_types", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "material_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible",          default: true
    t.boolean  "collapsed",        default: false
    t.index ["material_type_id"], name: "index_product_material_types_on_material_type_id", using: :btree
    t.index ["product_id"], name: "index_product_material_types_on_product_id", using: :btree
  end

  create_table "product_option_groups", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "locale_id"
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["locale_id"], name: "index_product_option_groups_on_locale_id", using: :btree
    t.index ["product_id"], name: "index_product_option_groups_on_product_id", using: :btree
  end

  create_table "product_options", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "content",                 limit: 255
    t.integer  "locale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price",                               default: 0.0
    t.integer  "product_option_group_id"
    t.index ["locale_id"], name: "index_product_options_on_locale_id", using: :btree
    t.index ["product_id"], name: "index_product_options_on_product_id", using: :btree
  end

  create_table "product_translates", force: :cascade do |t|
    t.integer  "locale_id"
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.float    "price"
    t.index ["locale_id"], name: "index_product_translates_on_locale_id", using: :btree
    t.index ["product_id"], name: "index_product_translates_on_product_id", using: :btree
  end

  create_table "product_type_translates", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "product_type_id"
    t.integer  "locale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_youtubes", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "link",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.float    "discount",                       default: 0.0
    t.boolean  "visible",                        default: true
  end

  create_table "registration_options", force: :cascade do |t|
    t.integer  "registration_id"
    t.integer  "course_option_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_option_id"], name: "index_registration_options_on_course_option_id", using: :btree
    t.index ["registration_id"], name: "index_registration_options_on_registration_id", using: :btree
  end

  create_table "registration_payments", force: :cascade do |t|
    t.float    "amount"
    t.string   "token"
    t.string   "bankcode"
    t.string   "account"
    t.datetime "expire_time"
    t.string   "trade_no"
    t.string   "trade_time"
    t.string   "payment_no"
    t.boolean  "completed"
    t.datetime "completed_time"
    t.string   "redirect_uri"
    t.boolean  "cancel",          default: false
    t.text     "cancel_reason"
    t.datetime "cancel_time"
    t.string   "payer_id"
    t.datetime "payment_time"
    t.integer  "registration_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "refunded",        default: false
    t.datetime "refunded_time"
    t.index ["registration_id"], name: "index_registration_payments_on_registration_id", using: :btree
  end

  create_table "registration_remittance_reports", force: :cascade do |t|
    t.float    "amount"
    t.string   "account"
    t.datetime "date"
    t.boolean  "confirm"
    t.integer  "registration_payment_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "message"
    t.index ["registration_payment_id"], name: "index_registration_remittance_report_to_payment", using: :btree
  end

  create_table "registrations", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed",                       default: false
    t.datetime "closed_time"
    t.string   "name",             limit: 255
    t.string   "phone",            limit: 255
    t.integer  "attendance",                   default: 0
    t.float    "subtotal",                     default: 0.0
    t.boolean  "returned",                     default: false
    t.datetime "returned_time"
    t.boolean  "canceled",                     default: false
    t.datetime "canceled_time"
    t.string   "email",            limit: 255
    t.text     "reason"
    t.string   "currency",         limit: 255
    t.integer  "locale_id"
    t.integer  "course_option_id"
    t.integer  "payment_method",               default: 0
    t.boolean  "checkout",                     default: false
    t.datetime "checkout_time"
    t.index ["course_option_id"], name: "index_registrations_on_course_option_id", using: :btree
  end

  create_table "remittance_translates", force: :cascade do |t|
    t.integer  "locale_id"
    t.string   "name",          limit: 255
    t.string   "account",       limit: 255
    t.string   "bank_name",     limit: 255
    t.string   "bank_address",  limit: 255
    t.string   "code",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "remittance_id"
    t.index ["remittance_id"], name: "index remittance_trnaslates on remittance_id", using: :btree
  end

  create_table "remittances", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_info_images", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_info_translates", force: :cascade do |t|
    t.integer  "rent_info_id"
    t.integer  "locale_id"
    t.string   "title",        limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_infos", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_intro_translates", force: :cascade do |t|
    t.integer  "rent_intro_id"
    t.integer  "locale_id"
    t.string   "description",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rent_intros", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirement_intro_translates", force: :cascade do |t|
    t.integer  "requirement_intro_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "title",                limit: 255
  end

  create_table "requirement_intros", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requirement_translates", force: :cascade do |t|
    t.integer  "requirement_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "title",          limit: 255
  end

  create_table "requirements", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "shipping_fee_translates", force: :cascade do |t|
    t.integer  "locale_id"
    t.integer  "shipping_fee_id"
    t.float    "fee"
    t.float    "free_condition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["locale_id"], name: "index_shipping_fee_translates_on_locale_id", using: :btree
    t.index ["shipping_fee_id"], name: "index_shipping_fee_translates_on_shipping_fee_id", using: :btree
  end

  create_table "shipping_fees", force: :cascade do |t|
    t.string   "area",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ships", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "paid"
    t.boolean  "delivered"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "completed"
    t.index ["order_id"], name: "index_ships_on_order_id", using: :btree
  end

  create_table "slide_positions", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "position",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slide_translates", force: :cascade do |t|
    t.integer  "locale_id"
    t.integer  "slide_id"
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link",        limit: 255
  end

  create_table "slides", force: :cascade do |t|
    t.integer  "sort"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "slide_position_id"
  end

  create_table "top_products", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "top_translates", force: :cascade do |t|
    t.integer  "top_id"
    t.string   "link",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.index ["locale_id"], name: "index_top_translates_on_locale_id", using: :btree
    t.index ["top_id"], name: "index_top_translates_on_top_id", using: :btree
  end

  create_table "tops", force: :cascade do |t|
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort"
  end

  create_table "travel_informations", force: :cascade do |t|
    t.integer  "area_id"
    t.string   "title",              limit: 255
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "travel_photos", force: :cascade do |t|
    t.integer  "travel_information_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "user_gift_payments", force: :cascade do |t|
    t.float    "amount"
    t.string   "token"
    t.string   "bankcode"
    t.string   "account"
    t.datetime "expire_time"
    t.string   "trade_no"
    t.datetime "trade_time"
    t.string   "payment_no"
    t.boolean  "completed"
    t.datetime "completed_time"
    t.string   "redirect_uri"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_gift_id"
    t.boolean  "cancel",         default: false
    t.text     "cancel_reason"
    t.datetime "cancel_time"
    t.string   "payer_id"
    t.datetime "payment_time"
    t.index ["user_gift_id"], name: "index_user_gift_payments_on_user_gift_id", using: :btree
  end

  create_table "user_gift_remittance_reports", force: :cascade do |t|
    t.float    "amount"
    t.integer  "account"
    t.datetime "date"
    t.boolean  "confirm"
    t.integer  "user_gift_payment_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "message"
    t.index ["user_gift_payment_id"], name: "index_user_gift_remittance_reports_on_user_gift_payment_id", using: :btree
  end

  create_table "user_gift_serials", force: :cascade do |t|
    t.integer  "user_gift_id"
    t.string   "serial",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "used_time"
    t.string   "email",           limit: 255
    t.integer  "order_id"
    t.integer  "registration_id"
    t.index ["order_id"], name: "index_user_gift_serials_on_order_id", using: :btree
    t.index ["registration_id"], name: "index_user_gift_serials_on_registration_id", using: :btree
    t.index ["user_gift_id"], name: "index_user_gift_serials_on_user_gift_id", using: :btree
  end

  create_table "user_gifts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "gift_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locale_id"
    t.string   "currency",        limit: 255
    t.integer  "order_id"
    t.integer  "registration_id"
    t.integer  "quantity"
    t.integer  "payment_method",              default: 0
    t.boolean  "checkout"
    t.datetime "checkout_time"
    t.index ["order_id"], name: "index_user_gifts_on_order_id", using: :btree
    t.index ["registration_id"], name: "index_user_gifts_on_registration_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                   limit: 255
    t.string   "name",                   limit: 255
    t.integer  "zip_code"
    t.string   "address",                limit: 255
    t.string   "line",                   limit: 255
    t.string   "phone",                  limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "token"
    t.datetime "token_expire"
    t.string   "redirect_url"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "order_remittance_reports", "order_payments"
  add_foreign_key "registration_remittance_reports", "registration_payments"
  add_foreign_key "user_gift_remittance_reports", "user_gift_payments"
end
