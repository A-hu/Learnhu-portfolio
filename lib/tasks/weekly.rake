namespace :weekly do

  task subscription: :environment do
    User.find_each do |user|
      weekly_topics = Topic.with_weekly_blogs
      UserMailer.subscribed(weekly_topics, user).deliver_now!
    end
  end
end
