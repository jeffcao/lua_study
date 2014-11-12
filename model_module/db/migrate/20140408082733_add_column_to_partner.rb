class AddColumnToPartner < ActiveRecord::Migration
  def change
    add_column  :partmers,:email,:string
  end
end
