class PostsController < ApplicationController
  before_action :find_post,only: [:show,:edit,:update,:destroy,:upvote,:downvote]
  before_action :authenticate_user!,except:[:index,:show]
  def index
    @posts = Post.all.order("created_at DESC")
  end
  def show
    @comment= Comment.where(post_id: @post)
  end
  def new
    @post =  current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post,notice: "Successfully created new post"
    else
      render'new'
    end
  end
  def edit
  end

  def update
    if @post.update(post_params)
    redirect_to @post,notice: "Pin successfully updated"
    else
      render'edit'
    end
  end
  def destroy
    @post.destroy
    redirect_to root_path
  end
  def upvote
    @post.upvote_by current_user
    redirect_to :back
  end
  def downvote
    @post.downvote_by current_user
    redirect_to :back
  end
  private
    def post_params
      params.require(:post).permit(:title,:description,:image)
    end
    def find_post
      @post = Post.find(params[:id])
    end
end
