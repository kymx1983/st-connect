class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :join, :unjoin, :destroy]
  
  def index
    @events = Event.all.order(date: :asc)
    @search_events = Event.search(params[:keyword])
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to root_path, notice: "イベントを作成しました"
    else
      flash[:alert] = "入力内容に誤りがあります。入力漏れ、文字数をご確認ください。"
      render :new
    end
  end

  def show
    @users = @event.users
    @owner = User.find_by(id: @event.owner)
    @comment = Comment.new
    @comments = @event.comments.includes(:user).order(created_at: :desc)
    if user_signed_in?
      @event_user = EventUser.where(event_id: @event.id, user_id: current_user.id)[0]
    end
  end
  
  def edit
  end
  
  def update
    if @event.update(event_params)
      redirect_to event_path, nootice: "イベントの編集が完了しました"
    else
      flash[:alert] = "未入力の項目があります"
      render :edit
    end
  end
  
  def destroy
    if @event.destroy
      redirect_to root_path, notice: "イベントを削除しました"
    else
      falsh[:alert] = "イベントの削除に失敗しました"
      render :show
    end
  end
  
  def join
    EventUser.create(user_id: current_user.id, event_id: @event.id)
    redirect_to event_path, notice: "イベントに参加しました"
  end
  
  def unjoin
    event_user = EventUser.where(user_id: current_user.id, event_id: params[:id])[0]
    event_user.destroy
    redirect_to event_path(params[:id]), notice: "イベントの参加をやめました"
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:id, :name, :place, :date, :open_time, :end_time ,:image, :description).merge(owner: current_user.id)
  end

end
