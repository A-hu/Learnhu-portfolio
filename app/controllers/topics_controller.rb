class TopicsController < ApplicationController
  before_action :about
  before_action :set_sidebar_topics
  before_action :find_topic, only: [:edit, :update, :destroy, :like]
  before_action :check_current_user, only: [:like]
  layout 'blog'

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find params[:id]

    if logged_in? :site_admin
      @topic_blogs = @topic.blogs.recent.page(params[:page]).per(5)
    else
      @topic_blogs = @topic.blogs.published.recent.page(params[:page]).per(5)
    end
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)

    if @topic.save
      redirect_to topics_path, notice: 'Blog was successfully created.' 
    else
      flash[:notice] = 'This title is been used.'
      render :new
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to topics_path, notice: 'Topic has been updated.'
    else
      render :edit
    end
  end

  def destroy
    begin
      @topic.destroy

      redirect_to topics_path, notice: 'Topic has been destroyed.'
    rescue ActiveRecord::InvalidForeignKey
      redirect_to topics_path, notice: 'This topic has many blogs.'
    end
  end

  def like
    like_topics = current_user.like_topics
    like_topics.include?(@topic) ? like_topics.delete(@topic) : like_topics << @topic

    respond_to do |format|
      format.html { redirect_to @topic }
      format.js
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title)
  end

  def find_topic
    @topic = Topic.find params[:id]
  end

  def set_sidebar_topics
    @side_bar_topics = Topic.with_blogs
  end

  def about
    @brief_about = User.find_by_roles( :site_admin ).brief_about
  end
end
