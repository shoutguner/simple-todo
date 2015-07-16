class CommentsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_filter :authenticate_user!

  before_filter :find_task

  def index
    @comments = @task.comments.to_a
  end

  def create
    @comment = @task.comments.build(comment_params)
    @comment.attachments = params[:comment][:attachments]
      if @comment.save
        render :show
      else
        render json: bad_response
      end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    if @comment.destroy
      render nothing: true
    else
      render json: bad_response
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def find_task
    @task = current_user.projects.find(params[:project_id]).tasks.find(params[:task_id])
  end

  def bad_response
    { comment: @comment, errors: @comment.errors.full_messages }
  end
end
