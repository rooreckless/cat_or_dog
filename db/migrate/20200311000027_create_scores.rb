class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.string :labelup, null: false
      t.float :probabityup, null: false
      t.string :labeldown, null: false
      t.float :probabitydown, null: false
      t.references :post, foreign_key: true
      #scoresテーブルはpostsテーブルのidを参照します。
      t.timestamps
    end
  end
end
