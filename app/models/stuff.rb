class Stuff < ApplicationRecord
	belongs_to :store
	has_many :chat_rooms

	def self.check_auth(params)
		where(uid: params[:auth_id], password: params[:auth_password]).first
	end
end
