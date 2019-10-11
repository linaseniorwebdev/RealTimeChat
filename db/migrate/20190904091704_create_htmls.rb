class CreateHtmls < ActiveRecord::Migration[5.2]
  def change
    create_table :htmls do |t|
    	t.text :data
      t.timestamps
    end
  end
end
