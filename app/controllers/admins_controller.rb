class AdminsController < ApplicationController
  include StoresHelper

  before_action :authenticate_admin_user!
  before_action :set_store, only: [:show, :edit, :update, :delete_site]

  def index
    @stores = Store.all
  end

  def create
    store = Store.create(store_params)

    set_store_error store.errors
    redirect_to store.valid? ? admins_path : new_admin_path(isNew: true)
  end

  def new
    set_store_error(nil) unless params[:isNew].present?
  end

  def show
  end

  def edit
    @store.sites.build if @store.sites.count.zero?
  end

  def destroy
    Store.find(params[:id].to_i).destroy!
    set_current_store(nil)
    redirect_to admins_path
  end

  def delete_site
    Site.find(params[:site_id].to_i).destroy!
    redirect_to edit_admin_path(@store)
  end

  def site
    @site = Site.find(params[:site_id])
  end

  def chatroom
    @chatRoom = ChatRoom.find(params[:chat_room_id].to_i)
  end

  def update
    @store.update(store_params)
    redirect_to admin_path(@store)
  end

  def store_params
    params.require(:store).permit(:auth_id, :name, :auth_password, sites_attributes: [:id, :uid, :name, :password, :url])
  end

  def set_store
    @store = Store.find(params[:id].to_i)
  end
end