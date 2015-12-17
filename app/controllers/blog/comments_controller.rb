class Blog::CommentsController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end

=begin
    def create
        post = Blog::Post.find(params[:id])
        comment = Blog::Comment.create!(comment_params)
        post.comments << comment
        current_user.comments << comment
    end
=end
    def new
        @blog_post = Blog::Post.find(params[:post_id])
        @blog_comment = Blog::Comment.new(:post_id => @blog_post)
    end

    def create 
        @blog_post = Blog::Post.find(params[:post_id])
        @blog_comment = @blog_post.comments.create!(blog_comment_params) 
        redirect_to @blog_post
    end
=begin
    def create
        @blog_post = Blog::Post.find(params[:post_id])
        @blog_comment = Blog::Comment.new(params[:comment])
        if @blog_comment.save
            flash[:notice] = "Successfully created comment."
            redirect_to @blog_post
        else
            render :action => 'new'
        end
    end
=end

private

    def blog_comment_params
        params.require(:comment).permit(:body, :author, :email)
    end
end