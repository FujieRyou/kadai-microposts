class FavoritesController < ApplicationController
  def create
    @micropost = Micropost.find(params[:micropost_id])
    @favorite = current_user.favorites.new(micropost_id: @micropost.id)
    @favorite.save
    redirect_to request.referrer
  end

  def destroy
    user = User.find(params[:id])
    current_user.unlike(user)
    redirect_to request.referer
    # @micropost = Micropost.find(params[:id])
    # @favorite = current_user.favorites.new(micropost_id: @micropost.id)
    # @favorite.destroy
    # redirect_to request.referer
  end
end
