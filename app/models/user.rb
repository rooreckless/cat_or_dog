class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  #上の記述は「ユーザテーブルからpostsテーブル」は1対多を表す
  validates :nickname, presence: true, uniqueness: true
  #deviseのuserモデルにはnicknameカラムを追加していますが、non nullかつ重複不可の制約を課しています。
end
