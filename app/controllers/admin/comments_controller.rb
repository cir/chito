class Admin::CommentsController < Admin::BaseController

    def index
	@comments = @user.find_feedbacks :type => :comments, :keyword => params[:keyword],
					:per_page => 25, :page => params[:page]
    end

    def destroy
        comment = @user.comments.find(params[:id])
	clean_email(comment)
	notice_stickie t(:comment_deleted, :scope => [:txt, :controller, :admin, :comments]) if comment.destroy
	sidebar_cache_expire(:new_comments)
	chito_cache_expire(:type => "posts_index/*")
	redirect_to admin_comments_path :keyword => params[:keyword], :page => params[:page]
    end

    def destroy_selected
	destroy_ids(params[:ids])
	notice_stickie t(:comments_deleted, :scope => [:txt, :controller, :admin, :comments])
	sidebar_cache_expire(:new_comments)
	chito_cache_expire(:type => "posts_index/*")
	redirect_to admin_comments_path :keyword => params[:keyword], :page => params[:page]
    end

    def settings
	get_comment_filters
	@enable_filters, @disable_filters = @filters.separate {|x| x.enable}
    end

    def set_filter_position
	get_comment_filters
	for field in ["enable_filters", "disable_filters"]
	    next unless params[field.to_sym]
	    params[field.to_sym].each_with_index do |id,idx| 
		bar = @filters.detect{|s| s.id == id.to_sym}
		bar.position = idx
		bar.enable = (field.to_sym == :enable_filters)
	    end
	end
	notice_stickie t(:filter_settings_updated, :scope => [:txt, :controller, :admin, :comments])
	redirect_to :action => "settings"
    end

    private

    def destroy_ids(ids)
	if ids
	    for comment in @user.feedbacks.find(ids)
		clean_email(comment)
		comment.destroy
	    end
	end	
    end

    def clean_email(comment)
	article = @user.articles.find(comment.article_id)
	if article && article.email && article.emails.has_key?(comment.email)
	    article.emails.delete(comment.email)
	    article.save
	end
    end
end
