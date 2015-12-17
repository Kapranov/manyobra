class PagesController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end

layout  "site"

    def index
        redirect_to action: :home, status: 302
    end

    def home
    end
    
    def services
        @message = Message.new
        if request.post?
            @message = Message.new(params[:message])
            if @message.valid?
              NotificationsMailer.new_message(@message).deliver
              redirect_to page_contact_path, :success => t('.email.alert.successful', name: @message.name, email: @message.email, phone: @message.phone)
            else
              #flash.now.alert = "Please fill all fields."
              render :contact
            end
        end
    end
    
    def prices
        @ordercall = Ordercall.new
        if request.post?
            @ordercall = Ordercall.new(params[:ordercall])
            if @ordercall.valid?
              NotificationsMailer.ordercall(@ordercall).deliver
              redirect_to page_prices_path, :success => t('.email.alert.successful', name: @ordercall.name, phone: @ordercall.phone)
            else
              #flash.now.alert = "Please fill all fields."
              render :prices
            end
        end
    end
    
    def events
    end

    def customers
    end

    def features
    end

    def contact
        @message = Message.new
        if request.post?
            @message = Message.new(params[:message])
            respond_to do |format|
                if @message.valid?
                    NotificationsMailer.new_message(@message).deliver
                    format.html { redirect_to page_contact_path, :success => t('.email.alert.successful', name: @message.name, email: @message.email, phone: @message.phone) }
                    format.json { render json: @message }
                else
                    #flash.now.alert = "Please fill all fields."
                    format.html { render :contact }
                    format.json { render json: @message.errors.full_messages, status: :unprocessable_entity }
                end
            end
        end
    end
    
    def order_call
        @ordercall = Ordercall.new
        if request.post?
            @ordercall = Ordercall.new(params[:ordercall])
            if @ordercall.valid?
              NotificationsMailer.ordercall(@ordercall).deliver
              render :contact
              #redirect_to page_contact_path, :success => t('.email.alert.successful', name: @ordercall.name, phone: @ordercall.phone)
            else
              #flash.now.alert = "Please fill all fields."
              render :contact
            end
        end
    end
     
    def sitemap
    end

    def sitemapxml
        path = Rails.root.join("public", "sitemaps", "sitemap.xml")
        if File.exists?(path)
          render xml: open(path).read
        else
          render text: "Sitemap not found.", status: :not_found
        end
    end

    def robots
    end
    
    def not_found
        #head :not_found
        render :status => 404
    end
 
end # end PagesController