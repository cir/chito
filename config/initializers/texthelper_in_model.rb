class ActiveRecord::Base
    def helpers
	ActionController::Base.helpers
    end
    #include ActionView::Helpers::TextHelper
    #include ActionView::Helpers::SanitizeHelper
end

#class ActionController::Base
#    def helpers
#	ActionController::Base.helpers
#    end
#end
