class BlogsController < ApplicationController
  before_action :about
  before_action :set_blog, only: [:show, :edit, :update, :destroy, :toggle_status, :like]
  before_action :set_sidebar_topics, except: [:update, :create, :destroy, :toggle_status]
  before_action :check_current_user, only: [:like]
  layout "blog"
  access all: [:show, :index], user: {except: [:destroy, :new, :create, :update, :edit, :toggle_status]}, site_admin: :all

  # GET /blogs
  # GET /blogs.json
  def index
    if logged_in? :site_admin
      @blogs = Blog.prior.recent.page(params[:page]).per(10)
    else
      @blogs = Blog.prior.not_draft.recent.page(params[:page]).per(10)
    end
    @page_title = "Learnhu Portfolio Blog"
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    if logged_in?(:site_admin) || !@blog.draft?
      @blog = Blog.includes(:comments).friendly.find(params[:id])
      @comment = Comment.new

      @page_title = @blog.title
      @seo_keywords = @blog.body
    else
      redirect_to blogs_path, notice: 'You are not authorized to access this page'
    end
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
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
    redirect_to blogs_url, notice: "Post status has been updated to #{@blog.status}."
  end

  def like
    like_blogs = current_user.like_blogs
    like_blogs.include?(@blog) ? like_blogs.delete(@blog) : like_blogs << @blog

    # https://coderwall.com/p/kqb3xq/rails-4-how-to-partials-ajax-dead-easy
    respond_to do |format|
      format.html { redirect_to @blog }
      format.js
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_blog
    @blog = Blog.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def blog_params
    params.require(:blog).permit(:title, :body, :topic_id, :status)
  end

  def set_sidebar_topics
    @side_bar_topics = Topic.with_blogs
  end

  def about
    @brief_about = User.find_by_roles( :site_admin ).brief_about
  end
end
