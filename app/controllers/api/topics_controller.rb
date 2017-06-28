module Api
  class TopicsController < ApplicationController
    before_action :find_topic, only: [:edit, :update, :destroy, :like]
    before_action :authenticate_user!, only: [:like]

    access all: [:show], user: {except: [:destroy, :new, :create, :update, :edit]}, site_admin: :all

    def index
      @topics = Topic.order(:title)

      render json: { topics: @topics }
    end

    def show
      @topic = Topic.find params[:id]

      if logged_in? :site_admin
        @blogs = @topic.blogs.prior.recent.page(params[:page]).per(5)
      else
        @blogs = @topic.blogs.prior.not_draft.recent.page(params[:page]).per(5)
      end

      render json: { topic: @topic, blogs: @blogs }
    end

    def new
      @topic = Topic.new
    end

    def create
      @topic = Topic.new(topic_params)

      if @topic.save
        render json: @topic
      else
        render json: @blog.errors, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @topic.update(topic_params)
        render json: @topic
      else
        render json: @blog.errors, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        @topic.destroy

        render json: { message: "success" }
      rescue ActiveRecord::InvalidForeignKey
        render json: { message: 'This topic may have many blogs.' }, status: 401
      end
    end

    def like
      like_topics = current_user.like_topics
      like_topics.include?(@topic) ? like_topics.delete(@topic) : like_topics << @topic

      render json: { topic_like: like_topics.include?(@topic) }
    end

    private

    def topic_params
      params.require(:topic).permit(:title, :body)
    end

    def find_topic
      @topic = Topic.find params[:id]
    end
  end
end
