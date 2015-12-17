class Blog::Tag < ActiveRecord::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
    has_many :taggings
    has_many :posts, through: :taggings

    def to_s
        name
    end
end