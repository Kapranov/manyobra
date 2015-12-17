class Blog::Comment < ActiveRecord::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
    belongs_to :post
    #attr_accessor :comment, :author, :body, :email

    validates :author, :body, :email, presence: true
    #validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
end