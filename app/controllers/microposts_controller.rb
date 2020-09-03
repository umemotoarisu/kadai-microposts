class MicropostsController < ApplicationController
   before_action :require_user_logged_in
   before_action :correct_user, only: [:destroy]

  def index
    @microposts = User.favorite.order.page(params[:id])
  end
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end
  
  def show
    @micropost = Micropost.find(params[:id])
    @favorite = @user.favorites.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  def likes
    @micropost = current_user.favorites
  end
  
  def favorite
    @micropost = current_user.favorite.page(params[:id])
  end 
  
  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
  
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    unless @micropost
      redirect_to root_url
    end
  end
  
  
end
