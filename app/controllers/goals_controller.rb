class GoalsController < ApplicationController

  before_action :check_logged_in

  def new
    @goal = Goal.new
    render :new
  end

  def create
    @goal = current_user.goals.new(goal_params)

    if @goal.save
      redirect_to user_url(current_user)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
    render :edit
  end

  def update
    @goal = Goal.find(params[:id])

    if @goal.update_attributes(goal_params)
      redirect_to user_url(current_user)
    else
      flash.now[:errors] = @goal.errors.full_messages
      render :edit
    end
  end

  def destroy
    goal = Goal.find(params[:id])
    goal.destroy!
    redirect_to user_url(current_user)
  end

  def index
    if logged_in?
      @goals = Goal.where("user_id = ? OR private = ?", current_user.id, false)
    else
      @goals = Goal.where("private = ?", false)
    end
    render :index
  end

  def complete
    @goal = Goal.find(params[:id])
    @goal.completed = !@goal.completed
    @goal.save

    redirect_to :back
  end

  private

    def goal_params
      params.require(:goal).permit(:name, :private, :completed)
    end

end
