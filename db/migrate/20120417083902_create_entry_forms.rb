class CreateEntryForms < ActiveRecord::Migration
  def up
    ######### entry forms and associated tables

    # this contains the information that the system needs to display and process 
    # the entry form. 
    # Each event contains exactly one entry form. 
    # entry forms belong to only one event
    # if you want to use the same type of entry form again on another event, copy it.
    create_table :entry_forms do |t|
      t.integer :event_id, :null => false

      [
        'sail_no',
        'boat_class',
        'boat_name',
        'boat_type',
        'boat_builder',
        'boat_model',
        'club',
        'owner_name',
        'contact_details',
        'isa_level',
        'handicap',
        'helm',
        'helm_details',
        'helm_club',
        'crew',
        'crew_club',
        'meal_preference',
        'fleet',
        'rig',
        'category',
        'guardian',
        'guardian_mobile',
        'helm_crew_guardian',
        'helm_crew_mobile',
        'non_spinnaker_class',
        'team_entry'
      ].each do |f|
        t.boolean :"display_#{f}", :null => false, :default => false
      end

      t.string :category_intro
      t.text :category_options, :limit => 1.megabyte

      t.string :payment_type
      t.text :layout_data, :limit => 1.megabyte

      t.timestamps
    end
    add_index :entry_forms, :event_id
    add_index :entry_forms, :created_at

    # entry forms can have multple charges
    # accomodation charges, meals, base prices, optional extras
    # we handle all these in one table and just display and process them differently 
    # depending on the type of charge
    create_table :charges do |t|
      t.integer :entry_form_id, :null => false
      t.string :type, :null => false
      t.string :name, :null => false
      t.decimal :price, :scale => 2, :precision => 12, :null => false
      t.decimal :discount_price, :scale => 2, :precision => 12
    end
    add_index :charges, :entry_form_id
    add_index :charges, :type
    add_index :charges, :price

    # assign classes to entry forms so that users can only entry from one
    # of the assigned classes
    # classes can belong to multiple entry forms and entry forms can have multiple classes
    create_table :boat_classes_entry_forms do |t|
      t.integer :entry_form_id, :null => false
      t.integer :boat_class_id, :null => false
    end
    add_index :boat_classes_entry_forms, :entry_form_id
    add_index :boat_classes_entry_forms, :boat_class_id

    # assign types of rigging to entry forms so that users can only choose from one
    # of the assigned rigs
    create_table :entry_forms_rigs do |t|
      t.integer :entry_form_id, :null => false
      t.integer :rig_id, :null => false
    end
    add_index :entry_forms_rigs, :entry_form_id
    add_index :entry_forms_rigs, :rig_id

    # this table links a set of likely clubs that the entry form will
    # display to allow users to choose from
    create_table :clubs_entry_forms do |t|
      t.integer :entry_form_id, :null => false
      t.integer :club_id, :null => false
    end
    add_index :clubs_entry_forms, :entry_form_id
    add_index :clubs_entry_forms, :club_id
    
    # this table creates custom fields for this entry form
    create_table :custom_fields do |t|
      t.integer :entry_form_id, :null => false
      t.string :datatype, :null => false
      t.string :name, :null => false
      t.text :extra
      t.boolean :is_required, :null => false, :default => false

      t.timestamps
    end

    ########################## entries and associated tables ###############

    # this represents a single entry by someone. 
    # It represents one boat in the event, but could have multiple crew
    create_table :entries do |t|
      t.integer :entry_form_id, :null => false
      t.integer :boat_class_id, :null => false

      t.string :sail_number_prefix, :limit => 3
      t.string :sail_number
      t.string :sail_number_suffix, :limit => 1

      t.string :boat_name
      t.string :owner_name
      t.float :loa
      t.float :lwl

      t.string :builder
      t.string :model
      t.string :rig_id

      t.string :category

      t.string :first_name
      t.string :last_name

      t.string :phone
      t.string :address_line_1
      t.string :address_line_2
      t.string :address_line_3
      t.string :address_line_4

      t.string :email

      t.integer :club_id
      t.string :club_name_extra

      t.string :helm_name
      t.string :helm_dob
      t.string :helm_phone
      t.string :helm_address_line_1
      t.string :helm_address_line_2
      t.string :helm_address_line_3
      t.string :helm_address_line_4
      t.integer :helm_club_id
      t.string :helm_club_name_extra

      t.string :crew_name
      t.string :crew_dob
      t.integer :crew_club_id
      t.string :crew_club_name_extra

      t.string :guardian
      t.string :guardian_mobile

      t.string :crew_guardian
      t.string :crew_guardian_mobile

      t.boolean :non_spinnaker_class

      t.string :status
      t.string :payment_status
      t.integer :payment_item_id

      t.text :custom_field_data, :limit => 1.megabyte

      t.text :additional_comment, :limit => 1.megabyte

      t.string :irc_cert_number
      t.string :echo_cert_number
      t.string :isa_level
      t.string :isa_year

      t.text :team_entry

      t.timestamps
    end
    add_index :entries, :entry_form_id
    add_index :entries, :last_name
    add_index :entries, :email
    add_index :entries, :club_id
    add_index :entries, :boat_class_id
    add_index :entries, :status
    add_index :entries, :payment_status
    add_index :entries, :created_at

    # which optional charges has this user accepted
    create_table :charges_entries do |t|
      t.integer :entry_id, :null => false
      t.integer :charge_id, :null => false
      t.integer :quantity, :null => false, :default => 1 # used in charges like meal tickets
      t.string :name # used in charges like accomodation charges
    end
    add_index :charges_entries, :entry_id
    add_index :charges_entries, :charge_id

    ######### general tables not associated with any particular entry or entry form
    # This represents a boat category e.g. Cruiser, Dinghy
    create_table :boat_categories do |t|
      t.string :name, :null => false
    end
    add_index :boat_categories, :name

    # This represents a boat class
    create_table :boat_classes do |t|
      t.string :name, :null => false
      t.integer :boat_category_id
    end
    add_index :boat_classes, :name
    add_index :boat_classes, :boat_category_id

    # This represents a type of rigging
    create_table :rigs do |t|
      t.string :name, :null => false
    end
    add_index :rigs, :name


    ## seed data
    classes = {'Cruiser' => ['Class 1', 'Class 2', 'Class 3'], 
      'One Design Keelboat' => ['Puppeteer', 'J24', 'Squib', 'Etchells', 'Howth 17', 'SB3'],
      'Dinghy' => ['Optimist', 'Laser', 'Topaz', 'RS Feva', 'Topper', 'Pico', 'Fireball', '420', 'Mirror']
    }

    # create seed boat category data
    BoatCategory.create(classes.keys.collect {|n| {:name => n} })

    # create seed boat class data
    classes_attrs = classes.collect do |category_name, names|
      bc = BoatCategory.find_by_name(category_name)
      names.collect { |n| {:name => n, :boat_category_id => bc.id} }
    end.flatten
    BoatClass.create(classes_attrs)

    # create rig data
    rigs = ['Standard', 'Radial', '4.7', 'Full', '4.2']
    Rig.create(rigs.collect {|n| {:name => n} })
  end

  def down
    [
      :entry_forms,
      :charges,
      :boat_classes_entry_forms,
      :entry_forms_rigs,
      :clubs_entry_forms,
      :entries,
      :charges_entries,
      :boat_categories,
      :boat_classes,
      :rigs,
      :custom_fields
    ].each do |t|
      drop_table t
    end
  end
end
