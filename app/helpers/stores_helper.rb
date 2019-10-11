module StoresHelper
	def set_current_store(id)
		session[:store_id] = id
	end

	def current_store
		session[:store_id].nil? ? nil : Store.find_by(id: session[:store_id].to_i)
	end

	def keep_route(route)
		session[:return_to] = route 
	end

	def prev_url
		session[:return_to]
	end

	def chat_enable
		session[:chat_enable] ||= true
	end

	def chat_enabled
		session[:chat_enable]
	end

	def set_store_error(errors)
		session[:erros] = errors
	end

	def get_store_error
		session[:erros]
	end


	def set_stuff(id)
		session[:stuff_id] = id
	end

	def current_stuff
		session[:stuff_id].nil? ? nil : Stuff.find_by(id: session[:stuff_id].to_i)
	end
end
