class StoresController < ApplicationController
	include StoresHelper
	before_action :check_auth, except: [:sign_in, :auth, :send_msg, :userout, :htmltag]
	before_action :set_store, only: [:show, :edit, :update, :set_item, :delete_item, :add_stuff, :stuff]

	def sign_in
		redirect_to store_path(current_store) unless current_store.nil?
	end

	def auth
		store = Store.check_auth(params[:store])
		
		if store.nil?
			stuff = Stuff.check_auth(params[:store])
			store = stuff.store unless stuff.nil?
			set_stuff(stuff.id) unless stuff.nil?
		end
		set_current_store(store.id) unless store.nil?
		redirect_to store.nil? ? sign_in_stores_path : store_path(id: store.id)
	end

	def show
		if params[:param].present?
			@site = Site.find(params[:param][:site_id]) if params[:param][:site_id].present?
		end
		@sites = @store.sites
		@chatRooms = ChatRoom.where(site_id: @sites.ids)
		@users = User.all
	end

	def edit
		@store.items.build if @store.items.count.zero?
	end

	def stuff
		@store.stuffs.build if @store.stuffs.count.zero?
	end

	def add_stuff
		@store.update(stuff_params) if params[:store].present?
		redirect_to store_path(id: @store.id)
	end

	def update
		@store.update(store_params)
		redirect_to edit_store_path
	end

	def message
		gon.chatEnabled = true
		gon.defaultEnable = true
		@chatRoom = ChatRoom.find(params[:chat_room_id])
	end
	
	def send_msg
		message = Message.create(message_params)
		message.chat_room.update(stuff_id: current_stuff.id) unless current_stuff.nil?
		if message.save
      ActionCable.server.broadcast 'messages',
        message: message.message,
        toUser: message.toUser,
        roomId: message.chat_room_id,
        isPayURL: message.isPayURL
      head :ok
    end
		# redirect_to request.referer
	end

	def set_item
		@store.items.update(selected: false)
		Item.find(params[:items][:item_id]).update(selected: true)
		redirect_to request.referer
	end

	def delete_item
		Item.find(params[:item_id].to_i).destroy! unless params[:item_id].to_i.zero?
		redirect_to edit_store_path
	end

	def delete_stuff
		Stuff.find(params[:stuff_id].to_i).destroy! unless params[:stuff_id].to_i.zero?
		redirect_to stuff_store_path
	end

	def delete_user
		user = User.find(params[:user_id].to_i)
		user.site_id = 0
		user.save

		redirect_to store_path(id: params[:id])
	end

	def check_auth
		if current_store.nil?
			redirect_to sign_in_stores_path
			return
		end
	end

	def set_store
		@store = Store.find_by(id: params[:id].to_i)
		render :file => "#{Rails.root}/public/404.html", :status => 404 if @store.nil?
	end

	def logout
		set_current_store 0
		set_stuff 0
		redirect_to sign_in_stores_path
	end

	def store_params
		params.require(:store).permit(:defaultEnable, :start_time, :end_time, items_attributes: [:id, :name, :url, :site_id])
	end

	def stuff_params
		params.require(:store).permit(stuffs_attributes: [:id, :name, :uid, :password])
	end

	def message_params
		params.require(:message).permit(:chat_room_id, :toUser, :isPayURL, :message)
	end
end
