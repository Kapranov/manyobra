class ApplicationController < ActionController::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com

 todo on this app
    blog
    statick pages
    tickets system
    user back end with features ...
    
=end
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.

    
    require 'net/http'
    protect_from_forgery with: :exception

    #skip_before_action :verify_authenticity_token, if: :json_request?
    
    before_filter :auto_get_locale  
    #before_filter :set_locale_from_url
    before_filter :set_locale, :get_user_locale, :set_timezone, :ref
    after_filter :store_location

    add_flash_types :success, :status, :error
    helper_method :facebook_likes_count, :facebook_likes


    def facebook_likes
      uri = URI("http://graph.facebook.com/40796308305")
      data = Net::HTTP.get(uri)
      @likes = JSON.parse(data)['likes']
    end

    def facebook_likes_count(url)
        uri = URI("https://graph.facebook.com/#{url}")
        data = Net::HTTP.get(uri)
        @likes = JSON.parse(data)['likes']
        return (@likes) ? @likes : "0"
    end

    def store_location
      # store last url - this is needed for post-login redirect to whatever the user last visited.
        return unless request.get? 
        if (request.path != "/users/sign_in" &&
            request.path != "/users/sign_up" &&
            request.path != "/users/password/new" &&
            request.path != "/users/sign_out" &&
            !request.xhr?) # don't store ajax calls
          session[:previous_url] = request.fullpath 
        end
    end

    def after_sign_in_path_for(resource)
        session[:previous_url] || root_path
    end

    def render404
        render :file => File.join(Rails.root, 'public', '404.html'), :status => 404, :layout => false
        return true
    end

    def auto_get_locale
        logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
        #I18n.locale = extract_locale_from_accept_language_header
        if extract_locale_from_accept_language_header.present?
            if not extract_locale_from_accept_language_header.match(/(es|en|ru)/)
                I18n.locale = I18n.default_locale
            end
        else
            I18n.locale = I18n.default_locale
        end
        logger.debug "* Locale set to '#{I18n.locale}'"
    end # auto_get_locale

    def set_locale
        session[:locale] = params[:locale] if params.include?('locale')
        I18n.locale = session[:locale]
        Rails.application.routes.default_url_options[:locale]= I18n.locale
    end # set_locale

    def get_user_locale
        session[:locale] = current_user.language if current_user if not params.include?('locale')
    end # get_user_locale

    #def current_user
    #    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    #end # current_user
    #helper_method :current_user

    def set_timezone
        Time.zone = current_user.time_zone if current_user
        logger.debug "* Timezone set to '#{Time.zone}'"
    end # set_timezone

    def full_name_user(user)
        full_name = user.first_name.to_s + " " + user.last_name.to_s if user.first_name.to_s.length + user.last_name.to_s.length > 0
        full_name
    end # full_name_user

    def ref2
        if request.env['affiliate.tag']
            text = "request.env['affiliate.tag'] = #{request.env['affiliate.tag']}"
        else
            text = "We're glad you found us on your own!"
        end
            @referal = text
    end

    def ref
        if request.env['affiliate.tag'] && User.find_by_email(request.env['affiliate.tag'])
            affiliate = User.find_by_email(request.env['affiliate.tag'])
            testreferal = "Halo, referral! You've been referred here by #{affiliate.first_name} from #{request.env['affiliate.from']} @ #{Time.at(env['affiliate.time'])}"
        else
            testreferal = "We're glad you found us on your own!"
        end
    end # ref

    def authorize
        redirect_to login_url, alert: "Not authorized" if current_user.nil?
    end # authorize

    def current_user
        @current_user ||= User.where("auth_token =?", cookies[:auth_token]).first if cookies[:auth_token]
        #old version
        #@current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user
    
    platform = RUBY_PLATFORM.match(/(linux|darwin)/)[0].to_sym
    Bundler.require(platform)
    

    protected

    def json_request?
        request.format.json?
    end

private

    def extract_locale_from_accept_language_header
        request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first rescue nil
    end


end # end class