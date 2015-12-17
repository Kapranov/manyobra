class UsersController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end

# Ruby library for phone number parsing, validation and formatting
#require 'phone'

before_filter :authorize, :except => [:new, :create]

 
 


=begin
'new' page is form for sign in
=end  
    def new
      @user = User.new
      #@user.build_profile
    end
=begin
'create' is not a page is resiver of post method of sign in form 
=end 
    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            #redirect_to @user, notice: "Thank you for signing up!"
            redirect_to dashboard_path, notice: "Thank you for signing up!"
        else
            render "new"
            #redirect_to login_path
        end
    end

    def show
      @user = current_user
    end

    def verification_mobile_number
        params[:page] ? @page = params[:page].to_i : @page = 0
        @page = 0 unless (0..3).include?(@page.to_i)
        @title = t :Enter_the_country_and_mobile_number_to_be_shown_when_calling_phones if @page == 0
        @title = t :Enter_the_code_we_sent_to_you_via_SMS if @page == 2
        @title = t :Caller_id_activated if @page == 3
        #title  title

        if @page == 0
            if request.post?
                if params[:verification][:number_for_verification].empty?
                    flash[:error] = t :The_field_is_blank_please_enter_your_number_and_click_Verify
                    redirect_to :action => 'verification_mobile_number', :page => '0'
                else
                    if params[:verification][:number_for_verification].length < 6
                        flash[:error] = t :The_number_is_too_short_please_enter_your_correct_number_and_click_Verify
                        redirect_to :action => :verification_mobile_number, :page => '0'
                    else
                        @verification = Verification.new
                        @verification.user_id = current_user
                        @verification.number_for_verification = params[:verification][:number_for_verification]
                        if @verification.save
                            flash[:error] = t :sending_sms
                            #api = Clickatell::API.authenticate('3418242', 'zetfon', 'OcfJURXJJZYQRd')
                            translated_message = t :Your_verification_code_Zetfon_for_activation_a_caller_identification
                            #api.send_message("#{@verification.number_for_verification}",  "#{translated_message} #{@verification.verification_code}")
                            # ????? ?????? ? ???????????? ?? sms
=begin
                            sms = SmsMessage.new
                            sms.sending_date = Time.now
                            sms.user_id = current_user.id
                            sms.reseller_id = current_user.owner_id
                            sms.number = @verification.number_for_verification
                            sms.save
=end
                            redirect_to :action => :verification_mobile_number, :page => '1'
                        else
                            flash[:error] = t :An_error_occurred_try_to_do_it_some_time_later_or_contact_customer_support
                            redirect_to :action => :profile
                        end
                    end
                end
            end
        end # end page 0
            
        if @page == 1
            @verification = Verification.select(params[:id]).where(:user_id => current_user).last
            if request.post?
                @verification = Verification.select(params[:id]).where(:user_id => current_user).last
                @verification.update_attributes(params[:verification])     
                if @verification.save
                    redirect_to :action => :verification_mobile_number, :page => '2'
                end
            end 
        end # end page 1

        if @page == 2
            if request.post?
                if params[:verification][:verification].empty?
                    flash[:error] = t :The_field_is_blank_please_enter_the_code_from_SMS_and_click_Verify
                    redirect_to :action => :verification_mobile_number, :page => '2'
                else
                    @verification = Verification.select(params[:id]).where(:user_id => current_user).last.tap do |v|
                    v.update_attributes(params[:verification])
                    v.save
                    end
                    session[:voucher_attempt] += 1
                    if session[:voucher_attempt] >= 10
                            flash[:error] = t :An_error_occurred_Too_many_wrong_attempts_try_to_do_it_some_time_later_or_contact_customer_support
                            redirect_to :action => :profile
                    end
                    
                    if @verification.confirmed?
                        flash[:success] = t'Pin_is_corect'
                        redirect_to :action => :profile
                    else
                        flash[:error] = t'The_code_was_not_recognized_please_re-enter_and_click_Verify'
                        redirect_to :action => :verification_mobile_number, :page => '2'
                        
                         if session[:voucher_attempt] >= 6
                            flash[:error] = t :An_error_occurred_Too_many_wrong_attempts_try_to_do_it_some_time_later_or_contact_customer_support
                            redirect_to :action => :profile
                         end
                    end
                end
            end # request.post?
        end # end page 2
    end # end verification_mobile_number

    def check_pincode
        @verification = Verification.find(params[:id]).tap do |v|
        v.verification params[:verification]
        v.save
        end
        if @verification.confirmed?
            flash[:success] = t :pin_is_corect
            redirect_to :action => :profile
        else
            flash[:error] = t :pin_is_no_corect
            redirect_to :action => :profile
        end
    end 

=begin
    def verification_mobile_number
    pincode = SecureRandom.random_number(9999)
    api = Clickatell::API.authenticate('3418242', 'zetfon', 'OcfJURXJJZYQRd')
    api.send_message("34691217202",  "Your verification code #{pincode}")

        title  t'Verification your mobile number'
        @user = current_user
        if request.post?
            @user.update_attributes(params[:user])
            if @user.save
                if params[:user][:validate_verification_pincode_for_sms] == pincode
                     flash[:success] = t'pin is corect #{pincode}'
                     redirect_to :action => 'profile'
                else
                     flash[:error] = t'pin is no corect, pin correct #{pincode}'
                     redirect_to :action => "profile"
                end
            else
                flash[:error] = t'pin is no corect problem model user'
                redirect_to :action => "profile"
            end
        end
    end
=end
=begin
    def validate_mobile_number
    

        title  t'Please inser code from SMS'
        @user = current_user
        if request.post?
            @user.update_attributes(params[:user])
            if @user.save
                if params[:user][:validate_verification_pincode_for_sms] == pincode
                     flash[:success] = t'pin is corect #{pincode}'
                     redirect_to :action => 'profile'
                else
                     flash[:error] = t'pin is no corect, pin correct #{pincode}'
                     redirect_to :action => "profile"
                end
            else
                flash[:error] = t'pin is no corect problem model user'
                redirect_to :action => "profile"
            end
        end
    end
=end
    def change_currency
        @user = current_user
        if request.post?
            #@user.update_attributes(params[:user][:currency_id])
            if @user.update_attributes(currency_params) 
                redirect_to profile_path, success: t('Default_currency_has_changed_from_now_will_see_prices_in, attribute: @user.currency')
            else
                redirect_to change_currency_path, error: t('Your_currency_has_not_been_changed')
            end
        end # request.post?
    end

    def change_time_zone
        @user = current_user
        if request.post?
            if @user.update_attributes(time_zone_params)
                redirect_to profile_path, success: t('Time_Zone_has_been_changed')
            else
                redirect_to change_time_zone_path, error: t('Time_Zone_has_not_been_changed')
            end
        end # request.post?
    end

    def change_language
        @user = current_user
        if request.post?
            @user.language = params[:user][:language]
            
            #@user.update_attribute(params[:user][:language])
            respond_to do |format|
                if @user.save
                    format.html { redirect_to :action => :profile and flash[:success] = I18n.t('Language_is_changed_to') +' '+ I18n.t(@user.language, :scope => 'languages.names') }
                    format.json { render json: @user.language, status: :created }
                else
                    format.html { flash[:error] = I18n.t('Language_no_changed') and render :action => :change_language }
                    format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end # request.post?
        end
    end
=begin
'profile' page
=end
    def profile
        @user = current_user
        #puts current_user.inspect
        
        if request.post?    
            if @user.update_attributes(profile_params)
                redirect_to profile_path, notice: I18n.t('Successfully_your_profile_has_been_updated.')
                session[:first_name] = @user.first_name
                session[:last_name] = @user.last_name
            else
                redirect_to profile_path, error: I18n.t('Your_profile_no_has_been_updated')
            end
        end # request.post?
    end # profile

    def profile_update
        @user = current_user
        if @user.update_attributes(profile_params)
            redirect_to profile_path, notice: I18n.t('Successfully changed password.')     
            session[:first_name] = @user.first_name
            session[:last_name] = @user.last_name
        else
            redirect_to profile_path, error: I18n.t('Your_profile_no_has_been_updated')
        end
    end
=begin
'dashboard' page
=end
    def dashboard

        @user = current_user
        @full_name = full_name_user(@user)
        #@user=User.find(:first, :include => [:tax], :conditions => ["users.id = ?", session[:user_id]])

        unless @user
          redirect_to logout_path and return false
        end       
    end # dashboard
=begin
'avatar' page
=end
    def avatar
        @user = current_user
        if request.post?
            @user.changing_avatar = true
            if @user.update_attributes(avatar_params)        
                flash[:success] = t :Profile_picture_is_changed
                redirect_to profile_path
            else
                flash[:error] = t :Profile_picture_has_not_been_changed
                render action: :avatar
            end
        end # request.post?
    end # avatar


private

=begin
'user_params' is params for create user in sign in page
=end

    def user_params
        params.require(:user).permit(
            :email, :password, :password_confirmation, :first_name, :last_name, :country, :language, :subscribed
            #profile_attributes: [:twitter_name, :github_name, :bio]
        )
    end # user_params
=begin
'profile_params' is params for update profile page
=end
    def avatar_params
        params.require(:user).permit(:avatar)
    end # avatar_params
=begin
'profile_params' is params for update profile page
=end
    def profile_params
        params.require(:user).permit(
            :first_name, :last_name, :birthday, :gender, :country, :city, :province, 
            :email, :mobile, :landline
        )
    end # profile_params
=begin
'currency_params' is params for update currency atribute in change_currency page
=end
    def currency_params
        params.require(:user).permit(:currency)
    end # currency_params
=begin
'currency_params' is params for update currency atribute in change_currency page
=end
    def time_zone_params
        params.require(:user).permit(:time_zone)
    end # currency_params
end