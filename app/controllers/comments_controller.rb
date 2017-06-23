class CommentsController < ApplicationController
  before_action :check_current_user
  before_action :find_comment, except: [:create]
  before_action :check_author, only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
  end

  def like
    like_comments = current_user.like_comments
    like_comments.include?(@comment) ? like_comments.delete(@comment) : like_comments << @comment

    respond_to do |format|
      format.html { redirect_to blog_path @comment.blog }
      format.js
    end
  end

  def destroy
    blog = @comment.blog
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to blog, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def find_comment
    @comment = Comment.find params[:id]
  end

  def check_author
    if @comment.user == current_user || logged_in?(:site_admin)
      @comment
    else
      redirect_to @comment.blog, notice: 'Permission denied'
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
