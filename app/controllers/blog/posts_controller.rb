class Blog::PostsController < ApplicationController
=begin
 Author: Andrey Zhuk
 Copyright (C) 2014 Zettheme. All Rights Reserved. http://www.zettheme.com
 Support:  support@zetheme.com
=end
  
  helper_method :sort_column, :sort_direction, :search_params, :facebook_likes_count

  before_action :set_blog_post, only: [:show, :edit, :update, :destroy]

  before_filter :authorize, :except => [ :index, :show ]
  layout  "blog"

  # GET /posts
  # GET /posts.json
  #def index
  #  @blog_posts = Blog::Post.search(params)
  #end

  def index
    @blog_posts = Blog::Post.all.includes(:tags, :comments)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @blog_post = Blog::Post.find_by_id(params[:id]) or render "pages/not_found"
    #@blog_post_comment = Blog::Comment.new(post_id: @blog_post.id)
    #@blog_comment = Blog::Comment.new(:post_id => @blog_post)
  end



  # GET /posts/new
  def new
    @blog_post = Blog::Post.new
  end

  # GET /posts/1/edit
  def edit
  end
  
  #def search
  #  @blog_post = Blog::Post.filter(params.slice(:status, :location, :starts_with))
  #end

  def search
    if params[:q].nil?
      @blog_post = []
    else
      @blog_post = Blog::Post.search params[:q]
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @blog_post = Blog::Post.new(blog_post_params)

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to blog_post_path(@blog_post), notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @blog_post }
      else
        format.html { render :new }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @blog_post.update(blog_post_params)
        format.html { redirect_to blog_post_path(@blog_post), notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog_post }
      else
        format.html { render :edit }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @blog_post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def to_param
    "#{id} #{slug}".parameterize
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog_post
      @blog_post = Blog::Post.find_by_id(params[:id])
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def search_params
      { :search => params[:search] }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_post_params
      params.require(:blog_post).permit(:title, :content, :slug, :author, :tag_list, :image)#, :status)
    end
end