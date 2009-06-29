class TrackbacksController < ApplicationController
    before_filter :get_user
    skip_before_filter :verify_authenticity_token


    def create
	@error_message = "Trackback not save"
	if @user.enable_trackbacks
	    post = @user.posts.find(params[:post_id])
	    if post && post.trackback_key == params[:key]
		@trackback = @user.trackbacks.new
		@trackback.prepare_trackback(request, params)
		@trackback.save && @error_message = ""
	    end
	end

	respond_to do |format|
	    format.xml  
	    format.html { render :nothing => true }
	end
    end

end
