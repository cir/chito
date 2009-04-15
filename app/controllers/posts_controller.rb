class PostsController < BlogController

  def show
    @post = @user.articles.find(params[:id])
    @comments = @post.comments
    respond_to do |format|
	format.html do
	    get_postbars
	    @category = @post.category
	    @comment = Feedback.new
	    @previous_post = @post.prev
	    @next_post = @post.next
	    @trackbacks = @post.trackbacks
	    @titles.unshift h(@post.title)
	    @title = @titles * " - "
	    do_something :before_post_show
	end
	format.rss
	format.xml {render :xml => @post.to_xml(:include => [ :comments ])}
    end

  end

  def index
    respond_to do |format|
	format.html do
	    unless chito_cache_enable(_params.merge(:type => :posts_index, :theme => @user.theme))
		@posts = @user.find_articles :type => :posts, :category_id => params[:category_id], 
					     :tag => params[:tag_name], :keyword => params[:s],
					     :page => params[:page], :per_page => @user.blog_per_page.to_num(10)
	    end
	    @category = @user.categories.find(params[:category_id]) if params[:category_id]
	    @titles.unshift(h @category.name) if @category
	    @title = @titles * " - "
	    do_something :before_list_show
	end
	format.rss do
	    @posts = @user.find_articles :type => :posts, :category_id => params[:category_id], 
					 :per_page => 12
	end
    end
  end

  def cancel_comment_notifier
    @post = @user.articles.find(params[:id])
    if @post.emails && @post.emails.has_key?(params[:email]) && @post.emails[params[:email]] == params[:key]
	@post.emails.delete(params[:email])
	@post.save
	notice_stickie t(:cancel_comment_notifier, :scope => [:txt, :controller, :posts], :title => @post.title) 
    else
	error_stickie t(:no_comment_notifier, :scope => [:txt, :controller, :posts], :title => @post.title)
    end
  end
end
