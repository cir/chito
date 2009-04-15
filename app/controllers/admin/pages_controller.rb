class Admin::PagesController <  Admin::ArticlesController

    def index
	@pages = @user.find_articles(:type => :pages, :page => params[:page], :per_page => 20)
    end

    def create
	super
	save_and_redirect
    end

    def update
	super
	save_and_redirect
    end

    def destroy
	super
	notice_stickie  t(:page_successfully_deleted, :scope => [:txt, :controller, :admin, :pages])
	redirect_to admin_pages_path(:page => params[:page]) 
    end

    private

    def save_and_redirect
	@article.is_draft = false
	@article.is_page = true
	@article.show_as_navbar = true
	unless_continue_edit { redirect_to page_path(@article) }
    end
end
