class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
    	t.belongs_to :chat_room, index: true
    	t.text :message
    	t.boolean :toUser, default: false
    	t.boolean :isPayURL, default: false
      t.timestamps
    end
  end
end
