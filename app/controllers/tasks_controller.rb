class TasksController < ApplicationController

  before_filter :authenticate_user!

  before_filter :find_project

  def create
    @task = @project.tasks.build(task_params)
    if @task.save
      render :show
    else
      render json: bad_response
    end
  end

  def destroy
    @task = @project.tasks.find(params[:id])
      if @task.destroy
        render nothing: true
      else
        render json: bad_response
      end
  end

  def update
    @task = @project.tasks.find(params[:id])
    # change task priority
    if params[:direction]
      Task.change_priority(@task.project_id, @task.id, @task.priority, params[:direction])
      @tasks = @project.tasks.all
      render :index
    # or update other task params
    else
      options = {}
      options.merge!({ done: !@task.done }) if params[:invert_status]
      options.merge!({ deadline: params[:deadline] }) if params[:deadline]
      if @task.update(task_params.merge(options))
        render :show
      else
        render json: bad_response
      end
    end
  end

  private

  def find_project
    @project = current_user.projects.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:text)
  end

  def bad_response
    { task: @task, errors: @task.errors.full_messages }
  end
end