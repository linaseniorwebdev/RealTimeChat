class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
    	t.string :token, unique: true
    	t.integer :site_id, default: 0
    	t.datetime :store_enter_time, default: Time.zone.now
      t.timestamps
    end
  end
end
