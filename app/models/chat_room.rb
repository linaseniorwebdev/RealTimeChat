class ChatRoom < ApplicationRecord
	belongs_to :site
	has_many :messages, dependent: :destroy
	belongs_to :stuff, optional: true

	def get_pays
		return self.messages.where(isPayURL: true).count
	end
end
