class ProjectsController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_filter :authenticate_user!, except: :root

  def root
    render :root
  end

  def index
    @projects = current_user.projects.to_a
  end

  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    if @project.save
      render :show
    else
      render json: bad_response
    end
  end

  def destroy
    @project = current_user.projects.find(params[:id])
    if @project.destroy
      render nothing: true
    else
      render json: bad_response
    end
  end

  def update
    @project = current_user.projects.find(params[:id])
    if @project.update(project_params)
      render :show
    else
      render json: bad_response
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def bad_response
    { project: @project, errors: @project.errors.full_messages }
  end
end