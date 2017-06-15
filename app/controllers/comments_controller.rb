class CommentsController < ApplicationController
  before_action :check_current_user, only: [:like]

  def create
    @comment = current_user.comments.build(comment_params)
  end

  def like
    @comment = Comment.find params[:id]
    like_comments = current_user.like_comments
    like_comments.include?(@comment) ? like_comments.delete(@comment) : like_comments << @comment

    respond_to do |format|
      format.html { redirect_to blog_path @comment.blog }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
