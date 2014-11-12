class ChangeApkSignaturePkPublicKey < ActiveRecord::Migration
  def up
    change_column :apk_signature_public_keys,:public_key,:text
  end

  def down
  end
end
