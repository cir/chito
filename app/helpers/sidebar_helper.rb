module SidebarHelper

    def sidebar(&block)
	@enable_bars.each{|item| yield item}
    end

    def bars_in(field)
	@enable_bars.select{|b| b.field.to_sym == field}.sort_by{|b| b.position}.each{|bar| yield bar}
    end

    def title_of(item)
	h(item.title)
    end

    def content_of(item)
	item.content.is_a?(String) ? item.content : send(:"show_#{item.id}_bar")
    end

    def id_of(item)
	item.id
    end    
end
