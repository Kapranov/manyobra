class PasswordsController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
    def index
        redirect_to change_password_path
    end
    def new
        @user = current_user
    end

    def create
        @user = current_user
        @user.changing_password = true
        if @user.update_attributes(password_params)
          redirect_to profile_path, notice: "Successfully changed password."
        else
          render "new"
        end
    end

private

    def password_params
        params.require(:user).permit(:original_password, :new_password, :new_password_confirmation)
    end
end