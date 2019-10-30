class AddBeamToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :beam, :string
  end
end
