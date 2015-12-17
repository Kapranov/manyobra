class User < ActiveRecord::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  require 'aws/s3'
  has_secure_password
  attr_accessor :changing_password, :changing_password_on_reset_link, :original_password, :new_password, :changing_avatar, :avatar, :avatar_file_name
  validates :email, :first_name, :last_name, :country, :language, presence: true
  validates_uniqueness_of :email
  #validates_length_of :username, minimum: 4, maximum: 20
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  validates_length_of :password, minimum: 6, on: :create
  validate :verify_original_password, if: :changing_password
  validates :original_password, :new_password, presence: true, if: :changing_password
  validates_confirmation_of :new_password, if: :changing_password
  validates_length_of :new_password, minimum: 6, maximum: 25, if: :changing_password

  validates :new_password, presence: true, if: :changing_password_on_reset_link
  validates_confirmation_of :new_password, if: :changing_password_on_reset_link
  validates_length_of :new_password, minimum: 6, maximum: 25, if: :changing_password_on_reset_link
  #old generate token
  #before_create :generate_token
  before_update :change_password, if: :changing_password
  before_update :change_password, if: :changing_password_on_reset_link




  has_one :profile
  accepts_nested_attributes_for :profile

  has_and_belongs_to_many :roles
  before_create { generate_token(:auth_token) }

  # Rails 4 version
  #has_attached_file :avatar, 
  #  :styles =>  { 
  #                :thumb => ["100x100#", :jpg],
  #                :original => ["240x240#", :jpg]
  #              },
     
  #  :default_url => "missing_:style.jpg"#, if: :changing_avatar

  has_attached_file :avatar, 
    :styles => lambda { |attachment| {
                                       :original => (attachment.instance ? "240x240#" : "240x240#"),
                                       :thumb => (attachment.instance ? "100x100#" : "100x100#") }
                                      },
    #:storage => :s3,
    #:s3_credentials => "#{Rails.root}/config/s3.yml",
    #:path => ':attachment/:id/:style.:extension',
    #:bucket => 'Zetfon_Avatars',
    :default_url => 'missing_:style.jpg'
  #has_attached_file :avatar,
  #          styles: lambda { |a| a.instance.is_image? ? {:small => "x200>", :medium => "x300>", :large => "x400>"}  : {:thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10}, :medium => { :geometry => "300x300#", :format => 'jpg', :time => 10}}}#, default_url: "missing_:style.jpg"

    
  #validates_attachment_content_type :avatar, 
  #  :size => { :in => 0..10.megabytes }, 
  #  :content_type => { :content_type => /^image\/(jpeg|png|gif|tiff)$/ }#, if: :changing_avatar
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
 
  #has_attached_file :avatar,
  #          styles: lambda { |a| a.instance.is_image? ? {:small => "x200>", :medium => "x300>", :large => "x400>"}  : {:thumb => { :geometry => "100x100#", :format => 'jpg', :time => 10}, :medium => { :geometry => "300x300#", :format => 'jpg', :time => 10}}}

  #def is_image?
  #          avatar.instance.attachment_content_type =~ %r(image)
  #end  
  
  # Send email for user with instruction to reset password
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  # Remember Me
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
    
  end
  
  def avatar_params
    params.require(:user).permit(:avatar_file_name, :description, :avatar)
  end

  def role?(role)
    return !!self.roles.find_by_name(role.to_s)
  end

  def make_admin
    self.roles << Role.admin
  end

  def revoke_admin
    self.roles.delete(Role.admin)
  end

  def admin?
    role?(:admin)
  end

  def subscribed
    subscribed_at
  end

  def subscribed=(checkbox)
    subscribed_at = Time.zone.now if checkbox == "1"
  end

  # generate token old version
  #def generate_token
  #  begin
  #    self.token = SecureRandom.hex
  #  end while User.exists?(token: token)
  #end

  def verify_original_password
    unless authenticate(original_password)
      errors.add :original_password, "is not correct"
    end
  end

  def change_password
    self.password = new_password
  end

  def to_param
    email
  end
end


 