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
    @aws_tweets = SocialTool.twitter_search "#aws", "popular"
    @rails_tweets = SocialTool.twitter_search "rubyonrails", "recent"
    @iot_tweets = SocialTool.twitter_search "#IoT", "popular"
    @ai_tweets = SocialTool.twitter_search "#ArtificialIntelligence", "popular"
  end
end
