module Api
  class BlogsController < ApplicationController
    before_action :set_blog, only: [:show, :edit, :update, :destroy, :toggle_status, :like]
    before_action :authenticate_user!, only: [:like]

    access all: [:show, :index], user: {except: [:index, :destroy, :new, :create, :update, :edit, :toggle_status]}, site_admin: :all

    def index
      if logged_in? :site_admin
        @blogs = Blog.prior.recent.limit(10)
      else
        @blogs = Blog.prior.not_draft.recent.limit(10)
      end

      render json: @blogs
    end

    def show
      if logged_in?(:site_admin) || !@blog.draft?
        @blog = Blog.includes(:comments).friendly.find(params[:id])
        render json: @blog
      else
        render json: { error: "Permission denied" }, status: 401
      end
    end

    def new
      @blog = Blog.new
    end

    def edit
    end

    def create
      @blog = Blog.new(blog_params)

      if @blog.save
        render :show, status: :created, location: @blog
      else
        render json: @blog.errors, status: :unprocessable_entity
      end
    end

    def update
      if @blog.update(blog_params)
        render :show, status: :ok, location: @blog
      else
        render json: @blog.errors, status: :unprocessable_entity
      end
    end

    def destroy
      if @blog.destroy
        render json: { message: "success" }
      else
        render json: { message: "Delete fail" }, status: 401
      end
    end

    def toggle_status
      if @blog.draft?
        @blog.published!
      elsif @blog.published?
        @blog.sticky!
      else
        @blog.draft!
      end

      render json: @blog
    end

    def like
      like_blogs = current_user.like_blogs
      like_blogs.include?(@blog) ? like_blogs.delete(@blog) : like_blogs << @blog

      render json: { blog_like: like_blogs.include?(@blog) }
    end

    private

    def set_blog
      @blog = Blog.friendly.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(:title, :body, :topic_id, :status)
    end
  end
end
