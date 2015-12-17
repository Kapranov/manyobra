class Blog::Tagging < ActiveRecord::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
    belongs_to :tag
    belongs_to :post
end