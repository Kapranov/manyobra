class ContactController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
    def new
        @message = Message.new
    end

    def create
        @message = Message.new(params[:message])
        if @message.valid?
            NotificationsMailer.new_message(@message).deliver
            redirect_to(page_contact_path, :notice => "Message was successfully sent.")
        else
            flash.now.alert = "Please fill all fields."
            render :new
        end
    end
end
