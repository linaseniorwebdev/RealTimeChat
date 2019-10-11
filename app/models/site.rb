class Site < ApplicationRecord
	belongs_to :store
	
	has_many :items
	has_many :histories
	has_many :chat_rooms, dependent: :destroy

	def get_pays
		cnt = 0
		chat_rooms.each do |room|
			cnt += room.get_pays
		end
		return cnt
	end
end
