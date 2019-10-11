class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
    	t.belongs_to :site, index: true
    	t.belongs_to :user, index: true
    end
  end
end
