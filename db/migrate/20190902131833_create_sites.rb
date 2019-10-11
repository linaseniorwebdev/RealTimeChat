class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.belongs_to :store, index: true
      t.string :uid
      t.string :name
      t.string :password
      t.string :url
      t.timestamps
    end
  end
end
