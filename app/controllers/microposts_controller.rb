class MicropostsController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy]
before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def like
    session[:return_to] ||= request.referrer
    if user_signed_in?
      @post = Post.find(params[:id])
      @post.liked_by current_user
      redirect_to session.delete(:return_to)
    else
      redirect_to session.delete(:return_to), notice: "You need to be signed in for that!"
    end
  end

  def unlike
    session[:return_to] ||= request.referrer
    if user_signed_in?
      @post = Post.find(params[:id])
      @post.unliked_by current_user
      redirect_to session.delete(:return_to)
    else
      redirect_to session.delete(:return_to), notice: "You need to be signed in for that!"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
