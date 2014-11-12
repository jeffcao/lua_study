class CreateApkSignaturePublicKeys < ActiveRecord::Migration
  def change
    create_table :apk_signature_public_keys do |t|
      t.integer :code
      t.string :name
      t.string :public_key

      t.timestamps
    end
  end
end
