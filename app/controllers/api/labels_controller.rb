class Api::LabelsController < ApplicationController
  def index
    labels = current_user.labels.all.to_json
    render json: labels
  end

  def create
    label = current_user.labels.build(label_params)
    if label.save
      head :no_content
    else
      render json: { error: shortcut.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def destroy
    @label = Label.find(params[:id])
    @label.destroy
    flash[:success] = 'ラベルを削除しました'
    redirect_to labels_path
  end

  private

  def label_params
    params.require(:label, {}).permit(:id, :title, :color)
  end
end
