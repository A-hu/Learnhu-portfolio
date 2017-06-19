class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.subscribed.subject
  #
  def subscribed(weekly_topics, user)
    @weekly_topics = weekly_topics
    @user = user

    mail(to: user.email, subject: "New Learnhu Posts of This Week")
  end
end
