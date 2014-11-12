class CreateAppErrorAcceptors < ActiveRecord::Migration
  def change
    create_table :app_error_acceptors do |t|
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
