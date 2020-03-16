class Post < ApplicationRecord
  validates :image, presence:true
  #Postモデルのpostsテーブルでは、imageカラムはnon null 制約をかけます。(createtableのmigrateでも書いたけど。)
  #参考ページ
  # https://qiita.com/wonder_meet/items/fa804f0d436a29c97460
  belongs_to :user
  #postモデルはuserモデル(devise)と1対1関係です。
  # belongs_to :score
  #scoreモデルとの1対1アソシエーションを組むことを断念しました。
  mount_uploader :image, ImageUploader
  #上は、imageカラムの内容(画像)をアップロードするために必要です。(carrierwaveGem)
  def self.returnthisweekposts(allposts)
    this_week = Date.yesterday.all_week
    #this_week = 今日の週です。範囲オブジェクt=>this_week= 2020-03-09..2020-03-15
    # weeklyposts=allposts.where(created_at: this_week).order("posts.created_at DESC")
    weeklyposts=allposts.where(created_at: this_week)
    puts "----allposts.where(created_at: this_week).count= #{weeklyposts}"
    
    # allposts.each do |post| 
    #   puts "---postroop--- allpost.length=#{allposts.length}"
    #   puts post
    #   if (this_week.include?(Date.parse(post[:created_at].to_s)))
    #     puts "--insideif post=#{post}--"
    #     @datas << post
    #   end
    #   # unless (this_week.include?(Date.parse(post[:created_at].to_s)))
    #   #   puts "--insideif post=#{post}--"
    #   #   allposts.delete(post)
    #   # end
    # end
    # puts "---postroop after--- allpost.length=#{allposts.length}"
    # puts "--post.rb @datas--"
    # puts @datas.length
    # puts "@datas[0]=#{@datas[0]}"
    # puts "@datas[0].created_at=#{@datas[0].created_at}"
    puts "allposts.class=#{allposts.class} @weeklyposts.class=#{weeklyposts.class}"
    return weeklyposts
    
  end
end
# 今週の日にちの中にpost[:created_at]の年月日が含まれていれば、trueを返す。
        # parseメソッドは、this_weekとpost[:created_at]のclassを合わせるために使用。
        # （this_weekはDateクラス, post[:created_at]はTimeWithZoneクラスのため）