class ActivityGalleryPlugin::ActivityGalleryBlock < Block

    metadata_items :activity_gallery_plugin_selected
  
    def self.description
      c_('Minha Galeria de Atividades')
    end
  
    def help
      _('Esse plugin exibe as atividades do usuário no RBAC')
    end
    
    def profile_activities(jwt)
      result = ActivityGalleryPlugin::Request.get('gallery/v1/activities/?per=50', nil, jwt)
      activities = JSON.parse(result.body,symbolize_names:true)[:data]
      .map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
      .select { |activity| activity.is_author?(owner) }
      activities.paginate(page: 1, per_page: 4)
    end

end
  