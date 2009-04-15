class Admin::RssController <  Admin::BaseController

  def index
    @manage = @rss_import_class = 'selected'
    @categories = @user.categories
  end 

  def import
    return unless request.post?
    if @user.import_rss(params[:rss_url], params[:import_category], params[:category], params[:import_comments])
	notice_stickie t(:rss_import_successfully, :scope => [:txt, :controller, :admin, :rss])
	render :partial => 'import'
    end
    rescue
	error_stickie t(:rss_import_fail, :scope => [:txt, :controller, :admin, :rss])
	render :partial => 'import'
  end

end
