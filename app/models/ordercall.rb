class Ordercall
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  include ActiveAttr::Model

  attribute :name
  attribute :phone
 
  validates :name, :phone, presence: true
end