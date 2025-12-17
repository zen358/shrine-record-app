# 参拝記録を管理するコントローラ
class ShrineRecordsController < ApplicationController
  # ログインユーザーのみアクセス可能
  before_action :authenticate_user!

  # 参拝記録一覧
  def index
    @shrine_records = current_user.shrine_records.order(visited_on: :desc)
  end

  # 新規作成フォーム
  def new
    # 空の参拝記録オブジェクトを作成
    @shrine_record = ShrineRecord.new
  end

  # 参拝記録の登録処理
  def create
    # ログインユーザーに紐づく参拝記録を作成
    @shrine_record = current_user.shrine_records.build(shrine_record_params)

    if @shrine_record.save
      # 保存成功時は一覧ページへリダイレクト（一覧ページは後で作成）
      redirect_to shrine_records_path, notice: "参拝記録を登録しました"
    else
      # 保存失敗時はフォームを再表示
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Strong Parameters(許可するパラメータを定義)
  def shrine_record_params
    params.require(:shrine_record).permit(
      :shrine_name,
      :deity,
      :visited_on,
      :wish,
      :memo,
      :latitude,
      :longitude
    )
  end
end
