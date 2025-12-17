class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 参拝記録との関連付け（1人のユーザーが複数の参拝記録を持つ）
  # dependent: :destroy でユーザー削除時に参拝記録も削除される
  has_many :shrine_records, dependent: :destroy

  # バリデーション
  validates :username, presence: true,
                       uniqueness: true,
                       length: { minimum: 2, maximum: 20 }
end
