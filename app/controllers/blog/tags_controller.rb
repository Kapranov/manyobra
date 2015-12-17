class Blog::TagsController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
	layout  "site"
	
	def show
	  	@blog_tag = Blog::Tag.find_by_id(params[:id]) or render "pages/not_found"
	  	#if ( @tag = nil )
	  	#	redirect_to blog_post_path
	  	#end
	end
end