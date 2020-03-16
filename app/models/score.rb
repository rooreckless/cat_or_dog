require 'aws-sdk'
class Score < ApplicationRecord
  belongs_to :post
  def self.createscore(filename_ext_removed,post_id)
    #以下は試しです。
    @post=Post.find(post_id)
    puts "--@post--"
    puts @post

    client = Aws::S3::Client.new(
      region: 'ap-northeast-1',
      access_key_id: Rails.application.secrets.aws_access_key_id,
      secret_access_key: Rails.application.secrets.aws_secret_access_key,
    )
    #上のclientは、awss3へ接続する(ダウンロードの)ために必要です。ないと403エラーです。
    s3data = client.get_object(bucket:'imagecheckhandsonnanonets',key:"judgepict/post/image/#{post_id}/#{filename_ext_removed}.json").body.read
    #上の行はclientが、s3にオブジェクト=jsonfileを取りに行き、その後、jsonファイルを読み込んで、中の文字列をs3dataとします。
    jsondata = JSON.parse(s3data)
    #上の行は、文字列をjsonに変えます。

    #デバッグ用表示部分です。
    puts 'jsondata[0].fetch("label")'
    puts "#{jsondata[0].fetch('label')}"
    puts 'jsondata[1].fetch("label")'
    puts "#{jsondata[1].fetch('label')}"
    puts 'jsondata[0].fetch("probability")'
    puts "#{jsondata[0].fetch('probability')}"
    puts 'jsondata[1].fetch("probability")'
    puts "#{jsondata[1].fetch('probability')}"
    #jsonのキーを書き換える方法はないかな？下のprivateメソッドのpermitで使えるかも。
    #binding.pry
    score=Score.new
    score.labelup=jsondata[0].fetch('label')
    score.probabilityup=jsondata[0].fetch('probability')
    score.labeldown=jsondata[1].fetch('label')
    score.probabilitydown=jsondata[1].fetch('probability')
    # score.post_id=post_id
    score.post_id=@post.id
    score.save!
    #以下は試しです。
    
    #self.create(score_params)
  end
  def self.returnscores(posts)
    # このメソッドは引数のpostsから1レコードずつpost_idで検索し、scoreレコードを抽出します。
    puts"----デバッグ returnscores----"
    # puts "posts=#{posts.ids}"
    # puts "posts.class = #{posts.class}"
    # # postsのクラスはAR_Rなので
    # @scores=where(post_id: posts.ids).order("posts.created_at DESC")
    @scores=where(post_id: posts.ids)
    puts @scores
    # puts "@scores.class = #{@scores.class}"
    
    # puts "(@scores)[0].class = #{(@scores)[0].class}"
    # puts "(@scores)[0].labelup = #{(@scores)[0].labelup}"
    # puts "(@scores)[0].probabilityup= #{(@scores)[0].probabilityup}"
    # @scores.each do |score|
    #   score.probabilityup=(50 + ((score).probabilityup*100 - 100).abs).to_i
    #   puts score.probabilityup
    # end
    # puts "--@scores--"
    # puts @scores
    return @scores
  end
  def self.return100score(a_val)
    # このメソッドは入力された小数点付き確率を、得点(100からマイナスした絶対値(整数化)して50に足す)化します。
    r_val=(50 + (a_val*100 - 100).abs).to_i
    return r_val
  end
  # private
  # def score_params
  #   params.permit(:label,:text).merge(post_id: .id)
  # end
end
