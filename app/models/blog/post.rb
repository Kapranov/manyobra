require 'elasticsearch/model'

class Blog::Post < ActiveRecord::Base
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    #include Tire::Model::Search
    #include Tire::Model::Callbacks
    #include Filterable
    
    validates_presence_of :content, :title

    settings index: { number_of_shards: 1 } do
        mappings dynamic: 'false' do
            indexes :title, analyzer: 'english'
            indexes :text, analyzer: 'english'
        end
    end

    #attr_accessible :title, :content, :published_at
     
     
    #searchable do
    #    text :title, :boost => 5
    #    text :content, :publish_month
    #    time :created_at
    #    string :publish_month
    #end
    
    has_attached_file :image,
    :styles =>  {
                  :original => {:geometry => '1280x1280>'},
                  :large => {:geometry => '1280x500>'},
                  :medium => {:geometry => '400x350>'},
                  :thumb => {:geometry => '100x100#'},
                  :mini => {:geometry => '50x50#'}

                },
    :default_url => ':style/missing.jpg'
    #:styles => lambda  { |attachment|  
    #                                   {
    #                                       :original => (attachment.instance ? "1280x1280#" : "1280x1280#"),
    #                                       :large => (attachment.instance ? "1280x500#" : "1280x500#"),
    #                                       :medium => (attachment.instance ? "400x350#" : "400x350#"),
    #                                       :thumb => (attachment.instance ? "100x100#" : "100x100#"),
    #                                       :mini => (attachment.instance ? "50x50#" : "50x50#") 
    #                                       }
    #                    }

    validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
    
    has_many :comments
    
    has_many :taggings
    has_many :tags, through: :taggings

    has_many :categorizing
    has_many :categories, through: :categorizing


    #def self.search(params)
    #  tire.search(load: true) do
    #    query { string params[:query]} if params[:query].present?
    #  end
    #end

    def self.search(query)
        __elasticsearch__.search(
            {
                query: {
                    multi_match: {
                        query: query,
                        fields: ['title^10', 'text']
                    }
                }
            }
        )
    end



    def tag_list
        self.tags.collect do |tag|
            tag.name
        end.join(", ")
    end

    def publish_month
        created_at.strftime("%B %Y")
    end

    def tag_list=(tags_string)
        tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
        new_or_found_tags = tag_names.collect { |name| Blog::Tag.find_or_create_by(name: name) }
        self.tags = new_or_found_tags
    end
end


# Delete the previous articles index in Elasticsearch
Blog::Post.__elasticsearch__.client.indices.delete index: Blog::Post.index_name rescue nil
 
# Create the new index with the new mapping
Blog::Post.__elasticsearch__.client.indices.create \
  index: Blog::Post.index_name,
  body: { settings: Blog::Post.settings.to_hash, mappings: Blog::Post.mappings.to_hash }
 
# Index all article records from the DB to Elasticsearch
#Article.import
Blog::Post.import # for auto sync model with elastic search