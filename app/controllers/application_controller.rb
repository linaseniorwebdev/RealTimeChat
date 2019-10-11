class ApplicationController < ActionController::Base
	before_action :get_customer, only: [:userout]

	def get_customer
		@user = User.find_by(id: cookies[:user_id])
	end
end
