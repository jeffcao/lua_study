#encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: "ddz<email@tblin.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.confirm.subject
  #
  def confirm
    @greeting = "Hi"

    mail to: "158139946@qq.com"
  end

  def send_email(email,new_pass)
    @password = new_pass
    subject = "用户忘记密码"
    mail to: email, subject: subject , content_type: 'text/html'
  end

end
