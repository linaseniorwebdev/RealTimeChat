class CreateStuffs < ActiveRecord::Migration[5.2]
  def change
    create_table :stuffs do |t|
    	t.belongs_to :store, index: true
    	t.string :uid
    	t.string :name
    	t.string :password
      t.timestamps
    end
  end
end
