class Role < ActiveRecord::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  has_and_belongs_to_many :users

  def self.admin
    find_or_create_by(:name => "admin")
  end

end
