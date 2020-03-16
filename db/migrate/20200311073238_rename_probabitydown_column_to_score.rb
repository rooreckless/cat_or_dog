class RenameProbabitydownColumnToScore < ActiveRecord::Migration[5.2]
  def change
    rename_column :scores, :probabitydown, :probabilitydown
    # scoreテーブルのカラム名を間違えてたので、変更します。
    #参考 https://qiita.com/libertyu/items/93acd8733e34b1d0a63c
  end
end
