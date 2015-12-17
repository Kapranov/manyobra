class UserMailer < ActionMailer::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  default from: "info@manyobra.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  # Send email for user with instruction to reset password
  def password_reset(user)
    @user = user
    mail :to => user.email#, :subject => t("Password_Reset")
  end
end