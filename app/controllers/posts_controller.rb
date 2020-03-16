# require 'aws-sdk'
class PostsController < ApplicationController
  before_action :move_to_index, except: [:index,:show]
  #index以外のアクションにはまず、このクラスのmove_to_indexメソッドを通します。
  def index
    @allposts = Post.includes(:user).order("created_at DESC")
    puts "---posts_controller index---"
    puts "@allposts.class = #{@allposts.class}"
    puts "(@allposts)[0].class = #{(@allposts)[0].class}"
    puts "---- #{@allscores = Score.returnscores(@allposts)}"
    @allscores = Score.returnscores(@allposts)
    #全体投稿データから今週の投稿データを作成
    @weeklyposts = Post.returnthisweekposts(@allposts)
    puts "---posts_controller index---"
    puts "@weeklyposts = #{@weeklyposts}"
    puts "@weeklyposts.class = #{@weeklyposts.class}"
    puts "(@weeklyposts)[0].class = #{(@weeklyposts)[0].class}"
    @weeklyscores = Score.returnscores(@weeklyposts)
    # puts "@numberonescore= #{@allscores.order("probabilityup ASC").limit(3)[0].probabilityup}"
    # puts "@numberonescore= #{@allscores.order("probabilityup ASC").limit(3)[0].post_id}"
    @regendscores =@allscores.order("probabilityup ASC").limit(3)
    # binding.pry
  end
  def new
    @post=Post.new
  end
  def create
    @post=Post.new(post_params)
    if (@post.save)
      sleep(15)
      if (@post!=nil)
        filename = @post.image.filename
        filename_ext_removed=filename.split('.')[0]
        Score.createscore(filename_ext_removed,@post.id)
        flash[:notice] = '投稿されました' 
      end
    else
      flash.now[:alert] = '画像は必ず投稿してください。'
      render :new
    end
  end
  def show
    @post = Post.find(params[:id])
    @score=Score.find_by(post_id: @post.id)
    @score_transed=Score.return100score(@score.probabilityup)
  end
  def destroy
    post = Post.find(params[:id])
    score=Score.find_by(post_id: post.id)
    score.destroy
    post.destroy
    flash.now[:notice] = '削除されました' 
    redirect_to root_path
  end
  private
  def post_params
    params.require(:post).permit(:image,:text).merge(user_id: current_user.id)
  end
  def move_to_index
    redirect_to(action: :index) unless user_signed_in?
  end
end
