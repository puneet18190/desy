class CreateMailingListAddresses < ActiveRecord::Migration
  def change
    create_table :mailing_list_addresses do |t|
      t.references :mailing_list_group, :on_delete => :cascade
      t.string :heading
      t.string :email

      t.timestamps
    end
  end
end
