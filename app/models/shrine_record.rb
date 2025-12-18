# 参拝記録モデル
class ShrineRecord < ApplicationRecord
  # Userとの関連付け（1人のユーザーが複数の参拝記録を持つ）
  belongs_to :user

  # 画像添付（Active Storage)
  has_one_attached :photo

  # バリデーション
  # 神社名は必須、100文字以内
  validates :shrine_name, presence: true, length: { maximum: 100 }

  # 参拝日は必須
  validates :visited_on, presence: true

  # 御祭神は任意、100文字以内
  validates :deity, length: { maximum: 100 }, allow_blank: true

  # お願いごとは任意、500文字以内
  validates :wish, length: { maximum: 500 }, allow_blank: true

  # メモは任意、1000文字以内
  validates :memo, length: { maximum: 1000 }, allow_blank: true

  # 緯度・経度は任意、数値のみ
  validates :latitude, numericality: true, allow_nil: true
  validates :longitude, numericality: true, allow_nil: true
end
