module ApplicationHelper
    include TagsHelper
    include ApplicationHelperPlugin

    def render_flash(options={})
	render_stickies({:close => t("txt.close") }.update(options))
    end

    def chito_cache(options={}, &block)
	cache( chito_cache_key(options), &block )
    end

    def sidebar_cache(id, options={}, &block)
	cache chito_cache_key(options.merge(:part => :plugins, :type => :sidebars, :id => id)), &block 
    end

    private

    def rewriter
	caller_method = (caller[0] =~ /`([^']*)'/ and $1)
	rewriter_method = "rewriter_of_#{caller_method}"
	if @user.send("enable_#{rewriter_method}") && respond_to?(rewriter_method)
	    send(rewriter_method)
	else
	    yield
	end
    end

    def arounder(&block)
	caller_method = (caller[0] =~ /`([^']*)'/ and $1)
	before_method = "before_#{caller_method}".to_sym
	after_method  = "after_#{caller_method}".to_sym
	html = ""
	html << show_something(before_method)
	html << capture(&block)
	html << show_something(after_method)
	html
    end
end
