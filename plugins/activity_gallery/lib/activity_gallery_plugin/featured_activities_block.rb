class ActivityGalleryPlugin::FeaturedActivitiesBlock < Block

    metadata_items :activity_gallery_plugin_selected
  
    def self.description
      'Exibir Atividades em Destaque'
    end
  
    def help
      'Este plugin exibe as atividades selecionadas pelo administrador do portal'
    end

    def activities
        if activity_gallery_plugin_selected.nil?
      return []
      else 
        result = ActivityGalleryPlugin::Request.get("gallery/v1/activities/?per=50", nil, nil)
        activities = JSON.parse(result.body,symbolize_names:true)[:data].
        map { |activity| ActivityGalleryPlugin::Activity.new(activity) }.
        select { |activity| activity_gallery_plugin_selected.include?(activity.id) }
        return activities
      end
    end
  
end
  