class PortfoliosController < ApplicationController
  def index
    @portfolios_items = Portfolio.all
  end
end
