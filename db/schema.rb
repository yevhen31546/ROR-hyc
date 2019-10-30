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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20190910041206) do

  create_table "admin_modules", :force => true do |t|
    t.string   "name"
    t.string   "controller"
    t.string   "action",            :default => "index"
    t.boolean  "active",            :default => false,   :null => false
    t.boolean  "superadmin_active", :default => true,    :null => false
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "admin_modules", ["active"], :name => "index_admin_modules_on_active"
  add_index "admin_modules", ["name"], :name => "index_admin_modules_on_name"
  add_index "admin_modules", ["parent_id"], :name => "index_admin_modules_on_parent_id"
  add_index "admin_modules", ["superadmin_active"], :name => "index_admin_modules_on_superadmin_active"

  create_table "admin_modules_users", :force => true do |t|
    t.integer "admin_module_id", :null => false
    t.integer "user_id",         :null => false
  end

  add_index "admin_modules_users", ["admin_module_id"], :name => "index_admin_modules_users_on_admin_module_id"
  add_index "admin_modules_users", ["user_id"], :name => "index_admin_modules_users_on_user_id"

  create_table "assets", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "category"
    t.integer  "width"
    t.integer  "height"
    t.string   "asset_file_name"
    t.integer  "asset_file_size"
    t.string   "asset_content_type"
    t.datetime "asset_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["category"], :name => "index_assets_on_category"
  add_index "assets", ["created_at"], :name => "index_assets_on_created_at"
  add_index "assets", ["name"], :name => "index_assets_on_name"
  add_index "assets", ["type"], :name => "index_assets_on_type"

  create_table "blog_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_categories", ["name"], :name => "index_blog_categories_on_name"

  create_table "blog_comments", :force => true do |t|
    t.integer  "blog_post_id"
    t.string   "author"
    t.string   "email"
    t.text     "comment"
    t.string   "status"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_comments", ["blog_post_id"], :name => "index_blog_comments_on_blog_post_id"
  add_index "blog_comments", ["created_at"], :name => "index_blog_comments_on_created_at"
  add_index "blog_comments", ["status"], :name => "index_blog_comments_on_status"

  create_table "blog_posts", :force => true do |t|
    t.string   "title"
    t.text     "content",            :limit => 2147483647
    t.string   "author"
    t.integer  "blog_category_id"
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.string   "image_content_type"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blog_posts", ["blog_category_id"], :name => "index_blog_posts_on_blog_category_id"
  add_index "blog_posts", ["created_at"], :name => "index_blog_posts_on_created_at"

  create_table "boat_builders", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "boat_builders", ["name"], :name => "index_boat_builders_on_name", :unique => true

  create_table "boat_categories", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "boat_categories", ["name"], :name => "index_boat_categories_on_name"

  create_table "boat_classes", :force => true do |t|
    t.string  "name",             :null => false
    t.integer "boat_category_id"
  end

  add_index "boat_classes", ["boat_category_id"], :name => "index_boat_classes_on_boat_category_id"
  add_index "boat_classes", ["name"], :name => "index_boat_classes_on_name"

  create_table "boat_classes_entry_forms", :force => true do |t|
    t.integer "entry_form_id", :null => false
    t.integer "boat_class_id", :null => false
    t.integer "position"
  end

  add_index "boat_classes_entry_forms", ["boat_class_id"], :name => "index_boat_classes_entry_forms_on_boat_class_id"
  add_index "boat_classes_entry_forms", ["entry_form_id"], :name => "index_boat_classes_entry_forms_on_entry_form_id"
  add_index "boat_classes_entry_forms", ["position"], :name => "index_boat_classes_entry_forms_on_position"

  create_table "bs_ads", :force => true do |t|
    t.string   "name"
    t.string   "ad_type"
    t.string   "category"
    t.string   "location"
    t.text     "description",      :limit => 16777215
    t.decimal  "price",                                :precision => 12, :scale => 2
    t.string   "currency"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "status"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "doc_file_name"
    t.string   "doc_content_type"
    t.integer  "doc_file_size"
    t.datetime "inactive_date"
    t.datetime "delete_date"
  end

  add_index "bs_ads", ["ad_type"], :name => "index_bs_ads_on_ad_type"
  add_index "bs_ads", ["category"], :name => "index_bs_ads_on_category"
  add_index "bs_ads", ["created_at"], :name => "index_bs_ads_on_created_at"
  add_index "bs_ads", ["currency"], :name => "index_bs_ads_on_currency"
  add_index "bs_ads", ["location"], :name => "index_bs_ads_on_location"
  add_index "bs_ads", ["name"], :name => "index_bs_ads_on_name"
  add_index "bs_ads", ["price"], :name => "index_bs_ads_on_price"
  add_index "bs_ads", ["status"], :name => "index_bs_ads_on_status"

  create_table "charges", :force => true do |t|
    t.integer  "entry_form_id",                                :null => false
    t.string   "charge_type",                                  :null => false
    t.string   "name",                                         :null => false
    t.decimal  "price",         :precision => 12, :scale => 2
    t.string   "group_name"
    t.string   "group_code"
    t.datetime "date"
    t.integer  "position"
    t.string   "heading"
    t.boolean  "is_hidden"
    t.string   "account_code"
  end

  add_index "charges", ["charge_type"], :name => "index_charges_on_type"
  add_index "charges", ["entry_form_id"], :name => "index_charges_on_entry_form_id"
  add_index "charges", ["is_hidden"], :name => "index_charges_on_is_hidden"
  add_index "charges", ["price"], :name => "index_charges_on_price"

  create_table "charges_entries", :force => true do |t|
    t.integer "entry_id",                 :null => false
    t.integer "charge_id",                :null => false
    t.integer "quantity",  :default => 1, :null => false
    t.string  "name"
  end

  add_index "charges_entries", ["charge_id"], :name => "index_charges_entries_on_charge_id"
  add_index "charges_entries", ["entry_id"], :name => "index_charges_entries_on_entry_id"

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.string   "initials"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clubs", ["initials"], :name => "index_clubs_on_initials"
  add_index "clubs", ["name"], :name => "index_clubs_on_name"

  create_table "clubs_entry_forms", :force => true do |t|
    t.integer "entry_form_id", :null => false
    t.integer "club_id",       :null => false
  end

  add_index "clubs_entry_forms", ["club_id"], :name => "index_clubs_entry_forms_on_club_id"
  add_index "clubs_entry_forms", ["entry_form_id"], :name => "index_clubs_entry_forms_on_entry_form_id"

  create_table "committees", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email"
  end

  create_table "contact_us", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.text     "message",       :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hyc_member"
    t.string   "function_date"
    t.string   "arrival_time"
    t.string   "num_attendees"
    t.string   "function_type"
    t.string   "menu"
  end

  create_table "contacts", :force => true do |t|
    t.string   "category"
    t.string   "name"
    t.string   "position"
    t.string   "email"
    t.string   "phone"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sub_position"
    t.string   "photo_file_name"
  end

  add_index "contacts", ["category"], :name => "index_contacts_on_category"
  add_index "contacts", ["created_at"], :name => "index_contacts_on_created_at"
  add_index "contacts", ["name"], :name => "index_contacts_on_name"
  add_index "contacts", ["sort_order"], :name => "index_contacts_on_sort_order"

  create_table "countries", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "countries", ["name"], :name => "index_countries_on_name", :unique => true

  create_table "countries_entry_forms", :id => false, :force => true do |t|
    t.integer "country_id"
    t.integer "entry_form_id"
  end

  add_index "countries_entry_forms", ["country_id"], :name => "index_countries_entry_forms_on_country_id"
  add_index "countries_entry_forms", ["entry_form_id"], :name => "index_countries_entry_forms_on_entry_form_id"

  create_table "crane_hire_bookings", :force => true do |t|
    t.boolean  "is_admin",                                                     :default => false, :null => false
    t.boolean  "is_member",                                                                       :null => false
    t.string   "owner_name",                                                                      :null => false
    t.string   "mobile",                                                                          :null => false
    t.string   "email",                                                                           :null => false
    t.string   "boat_name"
    t.string   "boat_type"
    t.string   "loa"
    t.string   "payment_ref"
    t.string   "crane_size"
    t.integer  "crane_hire_price_id"
    t.datetime "crane_hire_primary_start_at"
    t.datetime "crane_hire_secondary_start_at"
    t.boolean  "requested_cradle"
    t.datetime "cradle_hire_start_at"
    t.datetime "cradle_hire_end_at"
    t.boolean  "requested_dry_pad"
    t.boolean  "mast"
    t.boolean  "power_washer"
    t.boolean  "one_design"
    t.decimal  "total_charge",                  :precision => 10, :scale => 2
    t.text     "comments"
    t.datetime "created_at",                                                                      :null => false
    t.datetime "updated_at",                                                                      :null => false
    t.integer  "requested_cradle_days"
    t.integer  "payment_status",                                               :default => 0
    t.integer  "payment_item_id"
    t.string   "crane_in_out"
    t.string   "crane_op"
  end

  add_index "crane_hire_bookings", ["cradle_hire_end_at"], :name => "index_crane_hire_bookings_on_cradle_end_date"
  add_index "crane_hire_bookings", ["cradle_hire_start_at"], :name => "index_crane_hire_bookings_on_cradle_start_date"
  add_index "crane_hire_bookings", ["crane_hire_primary_start_at"], :name => "index_crane_hire_bookings_on_crane_hire_start_at"
  add_index "crane_hire_bookings", ["crane_hire_secondary_start_at"], :name => "index_crane_hire_bookings_on_crane_hire_end_at"
  add_index "crane_hire_bookings", ["created_at"], :name => "index_crane_hire_bookings_on_created_at"
  add_index "crane_hire_bookings", ["email"], :name => "index_crane_hire_bookings_on_email"
  add_index "crane_hire_bookings", ["is_admin"], :name => "index_crane_hire_bookings_on_is_admin"
  add_index "crane_hire_bookings", ["owner_name"], :name => "index_crane_hire_bookings_on_owner_name"
  add_index "crane_hire_bookings", ["payment_item_id"], :name => "index_crane_hire_bookings_on_payment_item_id"
  add_index "crane_hire_bookings", ["payment_status"], :name => "index_crane_hire_bookings_on_payment_status"

  create_table "crane_hire_prices", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "product_type"
    t.decimal  "member_price",     :precision => 10, :scale => 2
    t.decimal  "non_member_price", :precision => 10, :scale => 2
    t.string   "charge_period"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "crane_hire_prices", ["product_type"], :name => "index_crane_hire_prices_on_product_type"

  create_table "crew_finder_ads", :force => true do |t|
    t.string   "ad_type"
    t.text     "description"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "ip_address"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "age"
    t.string   "interested_in"
    t.string   "availability"
    t.string   "preferred_position"
    t.string   "experience"
  end

  create_table "crew_members", :force => true do |t|
    t.integer "entry_id",        :null => false
    t.string  "name",            :null => false
    t.date    "dob"
    t.integer "club_id"
    t.string  "club_name_extra"
    t.string  "phone"
    t.string  "guardian_name"
    t.string  "guardian_phone"
  end

  add_index "crew_members", ["entry_id"], :name => "index_crew_members_on_entry_id"

  create_table "custom_fields", :force => true do |t|
    t.integer  "entry_form_id",                    :null => false
    t.string   "datatype",                         :null => false
    t.string   "name",                             :null => false
    t.text     "extra"
    t.boolean  "is_required",   :default => false, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "entries", :force => true do |t|
    t.integer  "entry_form_id",                                                         :null => false
    t.integer  "boat_class_id"
    t.string   "sail_number_prefix",             :limit => 3
    t.string   "sail_number"
    t.string   "sail_number_suffix",             :limit => 1
    t.string   "boat_name"
    t.string   "owner_name"
    t.float    "loa"
    t.float    "lwl"
    t.string   "builder"
    t.string   "model"
    t.string   "rig_id"
    t.string   "category"
    t.string   "phone"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "address_line_4"
    t.string   "email"
    t.integer  "club_id"
    t.string   "club_name_extra"
    t.string   "helm_name"
    t.string   "helm_dob"
    t.string   "helm_phone"
    t.string   "helm_address_line_1"
    t.string   "helm_address_line_2"
    t.string   "helm_address_line_3"
    t.string   "helm_address_line_4"
    t.integer  "helm_club_id"
    t.string   "helm_club_name_extra"
    t.string   "crew_name"
    t.string   "crew_dob"
    t.integer  "crew_club_id"
    t.string   "crew_club_name_extra"
    t.string   "guardian"
    t.string   "guardian_mobile"
    t.string   "crew_guardian"
    t.string   "crew_guardian_mobile"
    t.boolean  "non_spinnaker_class"
    t.string   "status"
    t.string   "payment_status"
    t.integer  "payment_item_id"
    t.text     "custom_field_data",              :limit => 16777215
    t.text     "additional_comment",             :limit => 16777215
    t.string   "irc_cert_number"
    t.string   "crew_sailing_level"
    t.string   "isa_year"
    t.text     "team_entry"
    t.datetime "created_at",                                                            :null => false
    t.datetime "updated_at",                                                            :null => false
    t.boolean  "marina_accommodation_required"
    t.datetime "arrival_date"
    t.integer  "boat_builder_id"
    t.integer  "country_id"
    t.integer  "fleet_id"
    t.string   "helm_guardian"
    t.string   "helm_guardian_mobile"
    t.boolean  "loan_boat"
    t.boolean  "has_irc_cert_number",                                :default => false, :null => false
    t.boolean  "has_echo_cert_number",                               :default => false, :null => false
    t.boolean  "entered_in_results"
    t.string   "beam"
    t.string   "crew_phone"
    t.string   "crew_address_line_1"
    t.string   "crew_address_line_2"
    t.string   "crew_address_line_3"
    t.string   "crew_address_line_4"
    t.string   "crew_email"
    t.string   "helm_email"
    t.string   "helm_gender"
    t.string   "crew_gender"
    t.string   "crew_sailing_level_date"
    t.string   "helm_sailing_level"
    t.string   "helm_sailing_level_date"
    t.string   "boat_class_specific"
    t.boolean  "is_admin"
    t.integer  "entry_number"
    t.string   "team"
    t.string   "team_captain"
    t.string   "hull_colour"
    t.boolean  "is_isora_registered"
    t.boolean  "is_saturday_only_lambay"
    t.string   "entry_unique_booking_reference"
  end

  add_index "entries", ["boat_class_id"], :name => "index_entries_on_boat_class_id"
  add_index "entries", ["club_id"], :name => "index_entries_on_club_id"
  add_index "entries", ["created_at"], :name => "index_entries_on_created_at"
  add_index "entries", ["email"], :name => "index_entries_on_email"
  add_index "entries", ["entry_form_id"], :name => "index_entries_on_entry_form_id"
  add_index "entries", ["entry_number"], :name => "index_entries_on_entry_number"
  add_index "entries", ["entry_unique_booking_reference"], :name => "index_entries_on_entry_unique_booking_reference", :unique => true
  add_index "entries", ["is_admin"], :name => "index_entries_on_is_admin"
  add_index "entries", ["payment_status"], :name => "index_entries_on_payment_status"
  add_index "entries", ["status"], :name => "index_entries_on_status"

  create_table "entries_entry_form_categories", :force => true do |t|
    t.integer "entry_id"
    t.integer "entry_form_category_id"
    t.string  "value"
  end

  add_index "entries_entry_form_categories", ["entry_form_category_id"], :name => "index_entries_entry_form_categories_on_entry_form_category_id"
  add_index "entries_entry_form_categories", ["entry_id"], :name => "index_entries_entry_form_categories_on_entry_id"

  create_table "entry_form_categories", :force => true do |t|
    t.integer  "entry_form_id"
    t.string   "name"
    t.text     "options"
    t.integer  "position"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "short_options"
    t.boolean  "is_required"
  end

  add_index "entry_form_categories", ["entry_form_id"], :name => "index_entry_form_categories_on_entry_form_id"
  add_index "entry_form_categories", ["position"], :name => "index_entry_form_categories_on_position"

  create_table "entry_forms", :force => true do |t|
    t.integer  "event_id",                                                                     :null => false
    t.boolean  "display_sail_no",                                           :default => false, :null => false
    t.boolean  "display_boat_class",                                        :default => false, :null => false
    t.boolean  "display_boat_name",                                         :default => false, :null => false
    t.boolean  "display_boat_builder",                                      :default => false, :null => false
    t.boolean  "display_boat_model",                                        :default => false, :null => false
    t.boolean  "display_boat_type",                                         :default => false, :null => false
    t.boolean  "display_club",                                              :default => false, :null => false
    t.boolean  "display_owner_name",                                        :default => false, :null => false
    t.boolean  "display_contact_details",                                   :default => false, :null => false
    t.boolean  "display_helm_sailing_level",                                :default => false, :null => false
    t.boolean  "display_handicap",                                          :default => false, :null => false
    t.boolean  "display_helm",                                              :default => false, :null => false
    t.boolean  "display_helm_dob",                                          :default => false
    t.boolean  "display_helm_club",                                         :default => false, :null => false
    t.boolean  "display_crew",                                              :default => false, :null => false
    t.boolean  "display_crew_dob",                                          :default => false
    t.boolean  "display_crew_club",                                         :default => false, :null => false
    t.boolean  "display_fleet",                                             :default => false, :null => false
    t.boolean  "display_rig",                                               :default => false, :null => false
    t.boolean  "display_guardian",                                          :default => false, :null => false
    t.boolean  "display_non_spinnaker_class",                               :default => false, :null => false
    t.boolean  "display_team_entry",                                        :default => false, :null => false
    t.string   "category_intro"
    t.text     "category_options",                      :limit => 16777215
    t.string   "payment_type"
    t.text     "layout_data",                           :limit => 16777215
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.string   "handicap_note"
    t.string   "crew_note"
    t.string   "display_boat_type_note"
    t.text     "additional_note"
    t.boolean  "display_marina_accommodation_required"
    t.boolean  "display_arrival_date"
    t.string   "rig_note_1"
    t.string   "rig_note_2"
    t.string   "fleet_note"
    t.boolean  "display_country"
    t.boolean  "display_marina_accommodation_checkbox"
    t.string   "helm_dob_note"
    t.string   "crew_dob_note"
    t.boolean  "display_boat_builder_with_select"
    t.string   "guardian_note"
    t.boolean  "display_helm_guardian"
    t.boolean  "display_crew_guardian"
    t.boolean  "display_loan_boat"
    t.text     "entry_conditions",                      :limit => 16777215
    t.boolean  "display_beam"
    t.boolean  "display_helm_contact_details"
    t.boolean  "display_crew_contact_details"
    t.boolean  "display_helm_gender"
    t.boolean  "display_crew_gender"
    t.boolean  "display_helm_sailing_level_date"
    t.boolean  "display_crew_sailing_level"
    t.boolean  "display_crew_sailing_level_date"
    t.boolean  "display_boat_class_specific"
    t.boolean  "display_team"
    t.boolean  "display_team_captain"
    t.boolean  "display_hull_colour"
    t.text     "charge_note",                           :limit => 16777215
    t.boolean  "display_isora_registered",                                  :default => false
    t.text     "post_charge_note",                      :limit => 16777215
    t.boolean  "display_saturday_only_lambay",                              :default => false
  end

  add_index "entry_forms", ["created_at"], :name => "index_entry_forms_on_created_at"
  add_index "entry_forms", ["event_id"], :name => "index_entry_forms_on_event_id"

  create_table "entry_forms_fleets", :id => false, :force => true do |t|
    t.integer "entry_form_id", :null => false
    t.integer "fleet_id",      :null => false
  end

  add_index "entry_forms_fleets", ["entry_form_id"], :name => "index_entry_forms_fleets_on_entry_form_id"
  add_index "entry_forms_fleets", ["fleet_id"], :name => "index_entry_forms_fleets_on_fleet_id"

  create_table "entry_forms_rigs", :force => true do |t|
    t.integer "entry_form_id", :null => false
    t.integer "rig_id",        :null => false
  end

  add_index "entry_forms_rigs", ["entry_form_id"], :name => "index_entry_forms_rigs_on_entry_form_id"
  add_index "entry_forms_rigs", ["rig_id"], :name => "index_entry_forms_rigs_on_rig_id"

  create_table "entry_list_columns", :force => true do |t|
    t.integer "entry_list_id"
    t.string  "name"
    t.string  "entry_attr"
    t.integer "position"
  end

  add_index "entry_list_columns", ["entry_list_id"], :name => "index_entry_list_columns_on_entry_list_id"
  add_index "entry_list_columns", ["position"], :name => "index_entry_list_columns_on_position"

  create_table "entry_lists", :force => true do |t|
    t.integer "event_id"
    t.string  "name"
  end

  add_index "entry_lists", ["event_id"], :name => "index_entry_lists_on_event_id"

  create_table "event_dates", :force => true do |t|
    t.integer "event_id"
    t.date    "date",     :null => false
  end

  add_index "event_dates", ["date"], :name => "index_event_dates_on_date"
  add_index "event_dates", ["event_id"], :name => "index_event_dates_on_event_id"

  create_table "event_dinner_bookings", :force => true do |t|
    t.boolean  "is_admin"
    t.integer  "event_dinner_id"
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "table_name"
    t.integer  "quantity"
    t.decimal  "total_charge",    :precision => 10, :scale => 2
    t.integer  "payment_item_id"
    t.integer  "payment_ref"
    t.integer  "payment_status",                                 :default => 0
    t.text     "comments"
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "event_dinner_bookings", ["created_at"], :name => "index_event_dinner_bookings_on_created_at"
  add_index "event_dinner_bookings", ["email"], :name => "index_event_dinner_bookings_on_email"
  add_index "event_dinner_bookings", ["event_dinner_id"], :name => "index_event_dinner_bookings_on_event_dinner_id"
  add_index "event_dinner_bookings", ["is_admin"], :name => "index_event_dinner_bookings_on_is_admin"
  add_index "event_dinner_bookings", ["payment_status"], :name => "index_event_dinner_bookings_on_payment_status"
  add_index "event_dinner_bookings", ["table_name"], :name => "index_event_dinner_bookings_on_table_name"

  create_table "event_dinners", :force => true do |t|
    t.integer  "event_id"
    t.date     "event_date"
    t.decimal  "ticket_price",    :precision => 10, :scale => 2
    t.string   "table_name_type"
    t.text     "comments"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  add_index "event_dinners", ["event_date"], :name => "index_event_dinners_on_event_date"
  add_index "event_dinners", ["event_id"], :name => "index_event_dinners_on_event_id"

  create_table "event_logos", :force => true do |t|
    t.integer  "event_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "url"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "event_logos", ["event_id"], :name => "index_event_logos_on_event_id"

  create_table "event_resources", :force => true do |t|
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "resource_type"
    t.string   "occurrence"
    t.text     "comment"
    t.string   "url"
    t.string   "url_target"
    t.integer  "position"
    t.string   "resource_file_name"
    t.integer  "resource_file_size"
    t.string   "resource_content_type"
    t.datetime "resource_updated_at"
    t.string   "button_style"
  end

  add_index "event_resources", ["event_id"], :name => "index_event_resources_on_event_id"
  add_index "event_resources", ["occurrence"], :name => "index_event_resources_on_occurrence"
  add_index "event_resources", ["position"], :name => "index_event_resources_on_position"

  create_table "events", :force => true do |t|
    t.string   "title"
    t.string   "sub_title"
    t.text     "summary",                    :limit => 16777215
    t.date     "date"
    t.string   "status"
    t.string   "event_type"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sponsor_logo_file_name"
    t.string   "sponsor_logo_content_type"
    t.integer  "sponsor_logo_file_size"
    t.integer  "gallery_album_id"
    t.text     "dates_description"
    t.boolean  "is_featured"
    t.string   "featured_logo_file_name"
    t.string   "featured_logo_content_type"
    t.integer  "featured_logo_file_size"
    t.datetime "featured_logo_update_at"
    t.integer  "featured_position"
    t.string   "featured_url"
    t.date     "online_entry_show_date"
    t.date     "online_entry_hide_date"
    t.date     "entry_list_show_date"
    t.date     "entry_list_hide_date"
    t.boolean  "show_results",                                   :default => false
    t.string   "event_logo_file_name"
    t.integer  "event_logo_file_size"
    t.string   "event_logo_content_type"
    t.datetime "event_logo_updated_at"
    t.integer  "total_number_of_entries"
  end
  

  add_index "events", ["created_at"], :name => "index_events_on_created_at"
  add_index "events", ["date"], :name => "index_events_on_date"
  add_index "events", ["entry_list_hide_date"], :name => "index_events_on_entry_list_hide_date"
  add_index "events", ["entry_list_show_date"], :name => "index_events_on_entry_list_show_date"
  add_index "events", ["event_type"], :name => "index_events_on_event_type"
  add_index "events", ["featured_position"], :name => "index_events_on_featured_position"
  add_index "events", ["is_featured"], :name => "index_events_on_is_featured"
  add_index "events", ["online_entry_hide_date"], :name => "index_events_on_online_entry_hide_date"
  add_index "events", ["online_entry_show_date"], :name => "index_events_on_online_entry_show_date"
  add_index "events", ["show_results"], :name => "index_events_on_show_results"
  add_index "events", ["status"], :name => "index_events_on_status"
  add_index "events", ["sub_title"], :name => "index_events_on_sub_title"
  add_index "events", ["title"], :name => "index_events_on_title"

  create_table "feed_items", :force => true do |t|
    t.string   "feed_id"
    t.string   "entry_id"
    t.string   "title"
    t.string   "link"
    t.text     "summary"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feed_items", ["entry_id"], :name => "index_feed_items_on_entry_id", :unique => true
  add_index "feed_items", ["feed_id"], :name => "index_feed_items_on_feed_id"
  add_index "feed_items", ["published_at"], :name => "index_feed_items_on_published_at"

  create_table "feeds", :force => true do |t|
    t.string   "url"
    t.string   "format"
    t.integer  "update_interval",   :default => 600
    t.datetime "feed_requested_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["created_at"], :name => "index_feeds_on_created_at"
  add_index "feeds", ["updated_at"], :name => "index_feeds_on_updated_at"

  create_table "fleets", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "fleets", ["name"], :name => "index_fleets_on_name", :unique => true

  create_table "forem_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "forem_categories", ["slug"], :name => "index_forem_categories_on_slug", :unique => true

  create_table "forem_forums", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.integer "category_id"
    t.integer "views_count", :default => 0
    t.string  "slug"
  end

  add_index "forem_forums", ["slug"], :name => "index_forem_forums_on_slug", :unique => true

  create_table "forem_groups", :force => true do |t|
    t.string "name"
  end

  add_index "forem_groups", ["name"], :name => "index_forem_groups_on_name"

  create_table "forem_memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "member_id"
  end

  add_index "forem_memberships", ["group_id"], :name => "index_forem_memberships_on_group_id"

  create_table "forem_moderator_groups", :force => true do |t|
    t.integer "forum_id"
    t.integer "group_id"
  end

  add_index "forem_moderator_groups", ["forum_id"], :name => "index_forem_moderator_groups_on_forum_id"

  create_table "forem_posts", :force => true do |t|
    t.integer  "topic_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "reply_to_id"
    t.string   "state",       :default => "pending_review"
    t.boolean  "notified",    :default => false
  end

  add_index "forem_posts", ["reply_to_id"], :name => "index_forem_posts_on_reply_to_id"
  add_index "forem_posts", ["state"], :name => "index_forem_posts_on_state"
  add_index "forem_posts", ["topic_id"], :name => "index_forem_posts_on_topic_id"
  add_index "forem_posts", ["user_id"], :name => "index_forem_posts_on_user_id"

  create_table "forem_subscriptions", :force => true do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "forem_topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "locked",       :default => false,            :null => false
    t.boolean  "pinned",       :default => false
    t.boolean  "hidden",       :default => false
    t.datetime "last_post_at"
    t.string   "state",        :default => "pending_review"
    t.integer  "views_count",  :default => 0
    t.string   "slug"
  end

  add_index "forem_topics", ["forum_id"], :name => "index_forem_topics_on_forum_id"
  add_index "forem_topics", ["slug"], :name => "index_forem_topics_on_slug", :unique => true
  add_index "forem_topics", ["state"], :name => "index_forem_topics_on_state"
  add_index "forem_topics", ["user_id"], :name => "index_forem_topics_on_user_id"

  create_table "forem_views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",             :default => 0
    t.string   "viewable_type"
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
  end

  add_index "forem_views", ["updated_at"], :name => "index_forem_views_on_updated_at"
  add_index "forem_views", ["user_id"], :name => "index_forem_views_on_user_id"
  add_index "forem_views", ["viewable_id"], :name => "index_forem_views_on_topic_id"

  create_table "gallery_albums", :force => true do |t|
    t.string   "title"
    t.text     "content",                  :limit => 2147483647
    t.integer  "cover_photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gallery_category_id"
    t.integer  "position",                                       :default => 0
    t.text     "filter_event_desc"
    t.text     "filter_prize_giving_desc"
  end

  add_index "gallery_albums", ["created_at"], :name => "index_gallery_albums_on_created_at"
  add_index "gallery_albums", ["gallery_category_id"], :name => "index_gallery_albums_on_gallery_category_id"
  add_index "gallery_albums", ["position"], :name => "index_gallery_albums_on_position"

  create_table "gallery_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "parent_id"
    t.integer  "position"
  end

  add_index "gallery_categories", ["name"], :name => "index_gallery_categories_on_name"
  add_index "gallery_categories", ["parent_id"], :name => "index_gallery_categories_on_parent_id"
  add_index "gallery_categories", ["position"], :name => "index_gallery_categories_on_position"

  create_table "gallery_photos", :force => true do |t|
    t.integer  "gallery_album_id"
    t.string   "photo_file_name"
    t.integer  "photo_file_size"
    t.string   "photo_content_type"
    t.datetime "photo_updated_at"
    t.text     "caption"
    t.integer  "sort"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filter"
  end

  add_index "gallery_photos", ["created_at"], :name => "index_gallery_photos_on_created_at"

  create_table "navbar_items", :force => true do |t|
    t.integer  "navbar_id",                 :null => false
    t.integer  "parent_id"
    t.string   "name"
    t.string   "controller"
    t.string   "action"
    t.string   "parameters"
    t.string   "url"
    t.string   "target"
    t.integer  "page_id"
    t.integer  "asset_id"
    t.integer  "position",   :default => 0, :null => false
    t.string   "css_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "navbar_items", ["created_at"], :name => "index_navbar_items_on_created_at"
  add_index "navbar_items", ["name"], :name => "index_navbar_items_on_name"
  add_index "navbar_items", ["navbar_id"], :name => "index_navbar_items_on_navbar_id"
  add_index "navbar_items", ["parent_id"], :name => "index_navbar_items_on_parent_id"
  add_index "navbar_items", ["position"], :name => "index_navbar_items_on_position"

  create_table "navbars", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "navbars", ["code"], :name => "index_navbars_on_code"
  add_index "navbars", ["name"], :name => "index_navbars_on_name"

  create_table "news_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "news_categories", ["name"], :name => "index_news_categories_on_name"

  create_table "news_items", :force => true do |t|
    t.string   "title"
    t.text     "content",            :limit => 2147483647
    t.string   "image_file_name"
    t.integer  "image_file_size"
    t.string   "image_content_type"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "news_category_id"
    t.boolean  "is_junior"
    t.boolean  "featured"
    t.datetime "publish_at"
    t.integer  "ordering"
  end

  add_index "news_items", ["created_at"], :name => "index_news_items_on_created_at"
  add_index "news_items", ["is_junior"], :name => "index_news_items_on_is_junior"
  add_index "news_items", ["news_category_id"], :name => "index_news_items_on_news_category_id"

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "product_id",                                :null => false
    t.decimal  "amount",     :precision => 10, :scale => 2, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "member_name",                    :null => false
    t.string   "email",                          :null => false
    t.string   "member_id",                      :null => false
    t.integer  "payment_item_id"
    t.integer  "payment_status",  :default => 0
    t.string   "comment"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "code"
    t.text     "content",         :limit => 2147483647
    t.string   "extended_title"
    t.string   "seo_title"
    t.string   "seo_description"
    t.string   "robots"
    t.string   "string"
    t.string   "canonical"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "layout"
  end

  create_table "payment_items", :force => true do |t|
    t.string  "payment_id",     :limit => 50
    t.integer "user_id"
    t.integer "product_id"
    t.string  "product_type"
    t.string  "payment_method", :limit => 50
    t.decimal "amount",                        :precision => 8, :scale => 2
    t.string  "currency",       :limit => 10
    t.string  "last_digits",    :limit => 10
    t.integer "expiry_month",   :limit => 1
    t.integer "expiry_year",    :limit => 2
    t.string  "name_on_card",   :limit => 100
    t.text    "user_agent"
    t.string  "ip_address",     :limit => 50
    t.string  "authorization"
    t.string  "md"
    t.text    "pareq"
    t.string  "acsurl"
    t.string  "enc_salt"
    t.string  "enc_iv"
    t.text    "pas_ref"
    t.string  "batch_id"
  end

  add_index "payment_items", ["product_id"], :name => "index_payment_items_on_product_id"
  add_index "payment_items", ["product_type"], :name => "index_payment_items_on_product_type"
  add_index "payment_items", ["user_id"], :name => "index_payment_items_on_user_id"

  create_table "product_categories", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_categories", ["position"], :name => "index_product_categories_on_position"

  create_table "products", :force => true do |t|
    t.integer  "product_category_id"
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "products", ["position"], :name => "index_products_on_position"

  create_table "racings", :force => true do |t|
    t.date     "event_date"
    t.string   "race_officer"
    t.string   "assistant_race_officer"
    t.string   "boat_assisting"
    t.string   "classes_racing"
    t.string   "open_events_at_hyc"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "results", :force => true do |t|
    t.string   "class_name"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "event_id"
    t.string   "result_file_name"
    t.string   "result_content_type"
    t.integer  "result_file_size"
    t.datetime "result_file_updated_at"
    t.string   "event_logo_file_name"
    t.integer  "event_logo_file_size"
    t.string   "event_logo_content_type"
    t.datetime "event_logo_updated_at"
    t.string   "venue_logo_file_name"
    t.integer  "venue_logo_file_size"
    t.string   "venue_logo_content_type"
    t.datetime "venue_logo_updated_at"
    t.string   "event_title"
    t.integer  "year"
    t.string   "event_type"
    t.string   "ftp_path"
    t.integer  "position"
    t.integer  "event_position"
  end

  add_index "results", ["event_position"], :name => "index_results_on_event_position"
  add_index "results", ["event_type"], :name => "index_results_on_event_type"
  add_index "results", ["position"], :name => "index_results_on_position"
  add_index "results", ["year"], :name => "index_results_on_year"

  create_table "rigs", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "rigs", ["name"], :name => "index_rigs_on_name"

  create_table "role_resource_accesses", :force => true do |t|
    t.integer "object_id"
    t.string  "object_type"
    t.integer "role_id"
  end

  add_index "role_resource_accesses", ["object_id"], :name => "index_role_resource_accesses_on_object_id"
  add_index "role_resource_accesses", ["object_type"], :name => "index_role_resource_accesses_on_object_type"
  add_index "role_resource_accesses", ["role_id"], :name => "index_role_resource_accesses_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value",      :limit => 512
    t.string   "label"
    t.string   "value_type",                :default => "string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], :name => "index_settings_on_key"
  add_index "settings", ["label"], :name => "index_settings_on_label"

  create_table "social_events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "date"
    t.boolean  "featured"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_members", :force => true do |t|
    t.string   "name"
    t.string   "role"
    t.string   "department"
    t.string   "phone"
    t.string   "string"
    t.string   "mobile"
    t.string   "email"
    t.text     "content",            :limit => 2147483647
    t.integer  "sort"
    t.string   "photo_file_name"
    t.integer  "photo_file_size"
    t.string   "photo_content_type"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_members", ["sort"], :name => "index_team_members_on_sort"

  create_table "testimonials", :force => true do |t|
    t.string   "name"
    t.string   "from"
    t.text     "quote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "testimonials", ["created_at"], :name => "index_testimonials_on_created_at"

  create_table "tides", :force => true do |t|
    t.datetime "tide_at"
    t.float    "height"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tides", ["tide_at"], :name => "index_tides_on_tide_at"

  create_table "total_entries", :force => true do |t|
    t.string   "event_id"
    t.integer  "total_number_of_entries"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "trophy_events", :force => true do |t|
    t.string  "name"
    t.integer "year"
    t.string  "event_type"
    t.integer "position"
    t.boolean "boat"
    t.boolean "owner"
    t.boolean "helm"
    t.boolean "crew"
    t.boolean "club"
  end

  add_index "trophy_events", ["event_type"], :name => "index_trophy_events_on_event_type"
  add_index "trophy_events", ["position"], :name => "index_trophy_events_on_position"
  add_index "trophy_events", ["year"], :name => "index_trophy_events_on_year"

  create_table "trophy_winners", :force => true do |t|
    t.integer  "trophy_event_id", :null => false
    t.string   "trophy",          :null => false
    t.string   "category"
    t.string   "boat"
    t.string   "owner"
    t.string   "helm"
    t.string   "crew"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "club"
    t.integer  "position"
    t.text     "trophy_comment"
    t.string   "trophy_given_by"
  end

  add_index "trophy_winners", ["category"], :name => "index_trophy_winners_on_category"
  add_index "trophy_winners", ["created_at"], :name => "index_trophy_winners_on_created_at"
  add_index "trophy_winners", ["trophy"], :name => "index_trophy_winners_on_trophy"
  add_index "trophy_winners", ["trophy_event_id"], :name => "index_trophy_winners_on_event_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                                              :null => false
    t.string   "email"
    t.string   "crypted_password",                                   :null => false
    t.string   "password_salt",                                      :null => false
    t.string   "persistence_token",                                  :null => false
    t.string   "perishable_token"
    t.integer  "login_count",          :default => 0,                :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.boolean  "forem_admin",          :default => false
    t.string   "forem_state",          :default => "pending_review"
    t.boolean  "forem_auto_subscribe", :default => false
    t.integer  "role_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["created_at"], :name => "index_videos_on_created_at"

end
