class NotificationsMailer < ActionMailer::Base
    default :from => "noreply@manyobra.com"
    default :to => "info@manyobra.com"

    def new_message(message)
        @message = message
        mail(:subject => "[Manyobra.com] #{message.subject}")
    end

    def ordercall(ordercall)
        @ordercall = ordercall
        mail(:subject => "[Manyobra.com] order call")
    end
end