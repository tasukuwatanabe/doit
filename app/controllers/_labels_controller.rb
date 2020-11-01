class LabelsController < ApplicationController
  def index
    @label = Label.new
    @labels = current_user.labels.all
  end

  def create
    @label = current_user.labels.build(label_params)
    if @label.save
      flash[:success] = 'ラベルを作成しました'
    else
      flash[:danger] = 'ラベルの作成に失敗しました'
    end
    redirect_to labels_path
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    flash[:success] = 'ラベルを削除しました'
    redirect_to labels_path
  end

  private

  def label_params
    params.require(:label).permit(:title, :color)
  end
end
