class SessionsController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end

    def new
    end

    def create
        user = User.find_by_email(params[:email])
        if user && user.authenticate(params[:password])
            if params[:remember_me]
                cookies.permanent[:auth_token] = user.auth_token
            else
                cookies[:auth_token] = user.auth_token
            end
            redirect_to dashboard_url, :notice => t(".logged_in")
        else
            flash.now.alert = t("Email_or_password_is_invalid")
            render "new"
        end
    end

    def destroy
        cookies.delete(:auth_token)
        redirect_to login_url, :notice => t(".logged_out")
    end
end