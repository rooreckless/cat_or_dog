class UsersController < ApplicationController
  def show
    user=User.find(params[:id])
    #上の記述はshowが呼ばれた時のパラメータからusersテーブルを検索します。
    #下の記述ではログインして居る人のnicknameでUserモデルを検索します。
    #@user=current_user.nickname
    
    @posts=user.posts.order("created_at DESC")
    @nickname=user.nickname
    @scores = Score.returnscores(@posts)
    
  end
end
