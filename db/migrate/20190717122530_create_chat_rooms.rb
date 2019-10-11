class CreateChatRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_rooms do |t|
    	t.belongs_to :site, index: true
    	t.belongs_to :user, index: true
    	t.belongs_to :stuff
    	t.integer :visit_count, default: 0
      t.timestamps
    end
  end
end
