class ActivityGalleryPluginActivityController < ProfileController

    def list
        get_activities('gallery/v1/activities')
        @results = @activities[:data].paginate(page: params[:page] || 1, per_page: 6)
    end

    def item
        get_activities("gallery/v1/activities/#{params['id']}")
    end

    private

    def get_activities(url)
        result = ActivityGalleryPlugin::Request.get(url, session)
        @activities = JSON.parse(result.body,symbolize_names:true)
    end

end
