class PortfoliosController < ApplicationController
  before_action :about
  before_action :set_portfolio_item, only: [:show, :edit, :update, :destroy, :like]
  before_action :check_current_user, only: [:like]
  layout 'portfolio'
  access all: [:show, :index, :angular], user: {except: [:sort, :destroy, :new, :create, :update, :edit, :toggle_status]}, site_admin: :all

  def index
    @portfolio_items = Portfolio.by_position
  end

  def sort
    params[:order].each do |key, value|
      Portfolio.find(value[:id]).update(position: value[:position])
    end

    head :ok
  end

  def angular
    @portfolio_items = Portfolio.angular
  end

  def new
    @portfolio_item = Portfolio.new
  end

  def create
    @portfolio_item = Portfolio.new(portfolio_params)

    respond_to do |format|
      if @portfolio_item.save
        format.html { redirect_to portfolios_path, notice: 'Your portfolio item is now live' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @portfolio_item.update(portfolio_params)
        format.html { redirect_to portfolios_path, notice: 'The record successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def show
  end

  def destroy
    @portfolio_item.destroy

    respond_to do |format|
      format.html { redirect_to portfolios_path, notice: 'This portfolio successfully deleted' } 
    end
  end

  def like
    like_portfolios = current_user.like_portfolios
    like_portfolios.include?(@portfolio_item) ? like_portfolios.delete(@portfolio_item) : like_portfolios << @portfolio_item

    respond_to do |format|
      format.html { redirect_to @portfolio_item }
      format.js
    end
  end

  private

  def portfolio_params
    params.require(:portfolio).permit(:title,
                                      :subtitle,
                                      :body,
                                      :main_image,
                                      :thumb_image,
                                      technologies_attributes: [:id, :name, :_destroy]
                                     )
  end

  def set_portfolio_item
    @portfolio_item = Portfolio.find(params[:id])
  end

  def about
    @brief_about = User.find_by_roles( :site_admin ).brief_about
  end
end
