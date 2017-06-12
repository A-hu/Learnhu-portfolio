class PagesController < ApplicationController
  def home
    @posts = Blog.all
    @skills = Skill.all
  end

  def about
    @skills = Skill.all
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
