class Blog::Categorizing < ActiveRecord::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  belongs_to :category
  belongs_to :post
end
