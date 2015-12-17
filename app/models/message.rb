class Message
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  include ActiveAttr::Model

  attribute :name
  attribute :email
  attribute :phone
  attribute :subject
  attribute :message
  
  validates :name, :phone, presence: true
  validates :email, :format => { :with => %r{.+@.+\..+} }, :allow_blank => true
end