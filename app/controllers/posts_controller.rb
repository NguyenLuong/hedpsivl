class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :owned_post, only: [:edit, :update, :destroy]
    def index
      @posts = Post.paginate(page: params[:page], per_page: 5)
      @newposts = Post.all.order(created_at: :desc).limit(3)
    end
    
    def show
    end
    
    def new
      @post = current_user.posts.build
    end

    def create
      @post = current_user.posts.build(post_params)
      if @post.save
      flash[:success] = "Your post has been created!"
      redirect_to posts_path
      else
      flash[:alert] = "Your new post couldn't be created!  Please check the form."
      render :new
      end
    end
  
    def edit
      @post = Post.find(params[:id])
    end
    
    def update
      if @post.update(post_params)
        flash[:success] = "Post updated."
        redirect_to posts_path
      else
        flash.now[:alert] = "Update failed.  Please check the form."
        render :edit
      end
    end
    
    def destroy  
      @post = Post.find(params[:id])
      byebug
      @post.destroy
      redirect_to posts_path
    end  
    def like  
      if @post.liked_by current_user
        respond_to do |format|
          format.html { redirect_to :back }
          format.js
        end
      end
    end
    
    def unlike
      if @post.unliked_by current_user
        respond_to do |format|
          format.html { redirect_to :back }
          format.js
        end
      end
    end
    
    def tag
      @posts = Post.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 5)
    end
    private

    def post_params  
      params.require(:post).permit(:image, :caption, :tag_list)
    end
    
    def set_post
      @post = Post.find(params[:id])
    end
    
    def owned_post  
      unless current_user == @post.user
      flash[:alert] = "That post doesn't belong to you!"
      redirect_to root_path
      end
    end  
end
