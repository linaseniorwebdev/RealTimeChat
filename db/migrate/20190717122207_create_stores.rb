class CreateStores < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
    	t.string :auth_id, unique: true
    	t.string :auth_password
      t.string :name
    	t.boolean :defaultEnable, default: true
    	t.datetime :start_time
    	t.datetime :end_time
      t.timestamps
    end
  end
end
