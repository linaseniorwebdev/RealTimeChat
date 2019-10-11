class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
    	t.belongs_to :store, index: true
    	t.belongs_to :site
    	t.string :name
    	t.text :url
    	t.boolean :selected, default: false
    end
  end
end
