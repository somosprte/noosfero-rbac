class FeaturedContentPlugin::FeaturedContentBlock < Block

    metadata_items :featured_content_plugin_selected
  
    def self.description
      c_('Featured Content')
    end
  
    def help
      _('Plugin that highlights only selected articles.')
    end

    def articles
        if featured_content_plugin_selected.nil?
      return []
      else 
        Article.find(featured_content_plugin_selected.split(',')) 
      end
    end
  
end
  