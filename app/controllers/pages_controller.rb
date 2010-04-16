class PagesController < BlogController
    
    def show
	if params[:permalink]
	    @page = @user.pages.find_by_permalink(params[:permalink])
	else
	    @page = @user.pages.find(params[:id])
	end
	raise ActiveRecord::RecordNotFound unless @page
    end

end
