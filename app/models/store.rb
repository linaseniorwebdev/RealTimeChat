class Store < ApplicationRecord
	has_many :items, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :stuffs, dependent: :destroy

  accepts_nested_attributes_for :sites, allow_destroy: true
  accepts_nested_attributes_for :items, allow_destroy: true
  accepts_nested_attributes_for :stuffs, allow_destroy: true

	validates :auth_id, format: { with: /\A\d+\z/ }
	validates_length_of :auth_id, minimum: 6, maximum: 8
	validates_uniqueness_of :auth_id
	validates_length_of :auth_password, minimum: 8

	def self.check_auth(params)
		Store.where(auth_id: params[:auth_id], auth_password: params[:auth_password]).first
	end

	def get_pays
		cnt = 0
		sites.each do |site|
			cnt += site.get_pays
		end
		return cnt
	end

end
