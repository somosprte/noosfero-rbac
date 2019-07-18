class ActivityGalleryPluginProfileActivityController < ProfileController
    
    include ActivityGalleryPlugin::Helper
    no_design_blocks

    def index
        @activities = get("gallery/v1/activities/#{build_search_params}").
            map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
            .select { |activity| activity.is_author?(profile) } #FIXME REMOVE 
        @results = @activities.paginate(page: params[:page] || 1, per_page: 4)
    end

    def saved_activities
        @activities = get('user/v1/people/favorites/activities/?per=50') #CHANGE ENDPOINT
        .map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
        @results = @activities.paginate(page: params[:page] || 1, per_page: 4)
    end

    def implemented_activities
        @activities = get('user/v1/people/implementations/activities/?per=50') #CHANGE ENDPOINT
        .map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
        @results = @activities.paginate(page: params[:page] || 1, per_page: 4)
    end

end