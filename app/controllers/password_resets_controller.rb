class PasswordResetsController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  	def new
  	end

	def create
	    user = User.find_by_email(params[:email])
	    if user
	    	user.send_password_reset
	    	redirect_to login_url, :notice => t("Email sent with password reset instructions.")
		else
			redirect_to new_password_reset_path, :notice => t("email no exist")
		end
	end
	  
	def edit
	    @user = User.find_by_password_reset_token!(params[:id])
	end
	  
	def update
	    @user = User.find_by_password_reset_token!(params[:id]) rescue nil
	    @user.changing_password_on_reset_link = true
	    if @user.password_reset_sent_at < 2.hours.ago
	        redirect_to new_password_reset_path, :alert => "Password reset has expired."
	    elsif @user.update_attributes(password_params)
	        redirect_to login_url, :notice => t("Password has been reset!")
	    else
	        render :edit
	    end
    end

private

    def password_params
        params.require(:user).permit(:new_password, :new_password_confirmation)
    end
end