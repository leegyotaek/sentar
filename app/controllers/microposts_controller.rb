class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
 




  def show
    @micropost = Micropost.first
    @comment = @micropost.comments.build
  end


  def create
  @micropost = current_user.microposts.build(micropost_params)
  
  # 에러 발생시
  #  $ sudo apt-get update
  # $ sudo apt-get install imagemagick --fix-missing
    if @micropost.save
      flash[:success] = "게시글이 등록되었습니다.!"
      redirect_to current_user
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "게시글이 삭제 되었습니다."
    redirect_to current_user
  end

  def new
    
    @micropost = Micropost.new
  end

  
  def like
   @micropost = Micropost.find(params[:id])
   if current_user.already_liked?(@micropost) 
   @micropost.likes.find_by(user_id: current_user.id).destroy
   @micropost = Micropost.find(params[:id])
   respond_to do |format|
      format.html { redirect_back_or root_path}
      format.js
    end
   
 else
  @micropost.likes.create(user_id: current_user.id)
  unless current_user?@micropost.user
  title = "#{current_user.name}님이 #{@micropost.user.name}님의 글을 좋아합니다."
  message = @micropost.content + "<a href='/users/#{@micropost.user.id}/?from_pusher=#{@micropost.id}' >보러가기</a>"
  Pusher.trigger("mychannel-#{@micropost.user.id}", 'my-event', {:type => "like", :title=>title , :message => message, :url => current_user.gravatar_url } )
  Pusher.trigger("presence-sentar", 'test-event', {id:  current_user.id  } )

 
  @micropost.user.notify("#{current_user.name}님이 #{@micropost.user.name}님의 글을 좋아합니다.", "/users/#{@micropost.user.id}/?from_pusher=#{@micropost.id}" )
  end
  @micropost = Micropost.find(params[:id])
  
  respond_to do |format|
      format.html { redirect_back_or root_path }
      format.js
    end
  
 end


  end

  private
   
  def micropost_params
      params.require(:micropost).permit(:title, :content, :picture, :user_id)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
