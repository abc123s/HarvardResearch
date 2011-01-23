class Notifications < ActionMailer::Base
  default :from => "researchatharvard@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.signup.subject
  #
  def signup(user)
    @user = user
    @url = "http://www.harvard-research.com/welcome/" + user.id.to_s + '/' + user.code.to_s
    mail(:to => user.email,
         :subject => "HarvardResearch Registration Confirmation")
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.forgot_password.subject
  #
  def forgot_password
    @greeting = "Hi"

    mail :to => "to@example.org"
  end
end
