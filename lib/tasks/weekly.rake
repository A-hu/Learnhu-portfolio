namespace :weekly do

  task subscription: :environment do
    if Time.now.wday == 0
      User.find_each do |user|
        weekly_topics = Topic.with_weekly_blogs.to_a
        UserMailer.delay.subscribed(weekly_topics, user) if like_topics_renew user
      end
    end
  end

  def like_topics_renew user
    user.like_topics.includes(:blogs).where(blogs: {created_at: (Time.now - 7.day)..Time.now}).where.not(blogs: {status: 0}).present?
  end
end
