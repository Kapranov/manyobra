class Blog::SearchController < ApplicationController

    def search
        if params[:q].nil?
            @blog_posts = []
        else
            @blog_posts = Blog::Post.search params[:q]
        end
    end

end