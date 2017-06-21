class PagesController < ApplicationController
  def home
    @posts = Blog.all
    @skills = Skill.all
    @brief_about = User.find_by_roles( :site_admin ).brief_about
  end

  def about
    @about = User.find_by_roles( :site_admin ).about
    @skills = User.find_by_roles( :site_admin ).skills.order(:percent_utilized).reverse
  end

  def contact
  end

  def tech_news
    @watches = User.find_by_roles(:site_admin).watches
  end
end
