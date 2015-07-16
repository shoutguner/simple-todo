class DownloadsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_filter :authenticate_user!

  def download
    @comment = Comment.find(params[:comment_id])
    if @comment.task.project.user_id == current_user.id
      # for normal hosting
      # send_file "#{Rails.root.join('uploads', 'comment', 'attachments').to_s}/#{@comment.id}/#{params[:file_name]}.#{params[:format]}"

      # for heroku
      send_file "tmp/uploads/comment/attachments/#{@comment.id}/#{params[:file_name]}.#{params[:format]}"
    else
      render json: not_own
    end
  end

  private

  def not_own
    { errors: ['You not own this file.'] }
  end
end
