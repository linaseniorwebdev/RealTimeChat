class MessagesChannel < ApplicationCable::Channel
	def subscribed
		stream_from 'messages'
	end

	def unsubscribed
		logger.info "______UNSUBSCRIBE______"
		super
	end

	def close(data)
		logger.info "______CLOSE______"
		user = User.find_or_create_by(token: data['token'])
    user.update(site_id: 0)
		site = Site.find_by(url: data['url'])

		# logger.info "______CLOSE______#{User.all.pluck(:id, :token, :site_id)}"
		# logger.info "______CLOSE______#{site.store.site_ids}"

		ActionCable.server.broadcast "messages", 
    	user_site_ids: User.all.pluck(:site_id),
      site_ids: site.store.site_ids
    true
	end

	def speak(data)
    logger.info "______________#{data['url']}"

    site = Site.where("url LIKE ?", "%#{data['url']}%").first

    return if site.nil?

    user = User.find_or_create_by(token: data['token'])
    user.update(site_id: site.id, store_enter_time: Time.zone.now) unless user.site_id == site.id
    room = ChatRoom.find_or_create_by(user_id: user.id, site_id: site.id)

    if data['data'].nil? or data['data'].empty?
    	history = History.create(user_id: user.id, site_id: site.id)
    	store = site.store

    	chatEnabled = store.defaultEnable
			current_time = Time.zone.now.strftime('%H:%M')
			start_time = store.start_time.nil? ? Time.parse('0am').strftime('%H:%M') : store.start_time.strftime('%H:%M')
			end_time = store.end_time.nil? ? Time.parse('23:59').strftime('%H:%M') : store.end_time.strftime('%H:%M')
			if start_time > end_time
				defaultEnable = current_time > start_time || current_time < end_time
			else
				defaultEnable = current_time > start_time && current_time < end_time
			end
			defaultEnable = false if Time.zone.now - user.created_at < 2

			userIndex = User.where(site_id: store.site_ids).order(:store_enter_time).collect(&:id).find_index(user.id) if room.messages.count.zero?


      logger.info "_______DATA___NULL"
    	ActionCable.server.broadcast "messages", 
	    	messages: room.messages,
	    	chatEnabled: chatEnabled,
	    	defaultEnable: defaultEnable,
	    	user_site_ids: User.all.pluck(:site_id),
	      site_ids: store.site_ids,
	      userIndex: userIndex,
	      roomId: room.id
	    true

    else
      logger.info "_______DATA__NOT__NULL"

    	Message.create(
	    	chat_room_id: room.id,
	    	message: data['data']
   		)

   		ActionCable.server.broadcast "messages", 
	    	message: data['data'],
	    	toUser: false,
	    	isPayURL: false,
	    	roomId: room.id,
	    	isFrontEnd: true
	    true
    end
  end
end
