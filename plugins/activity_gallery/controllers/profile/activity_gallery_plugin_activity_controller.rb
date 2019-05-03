class ActivityGalleryPluginActivityController < ProfileController

    def search_authors
        arg = params[:q].downcase
        authors = get_authors('user/v1/people')
        result = authors.select do |author|
            author[:attributes][:name].downcase.match(/#{arg}/).present?
        end.map {|author| {id: author[:id], name: author[:attributes][:name]}}
        render plain: result.to_json
    end

    def list
        if params[:search]
        get_activities("gallery/v1/activities?global=#{params[:search]}")
        else
        get_activities('gallery/v1/activities')
        end
        @results = @activities[:data].paginate(page: params[:page] || 1, per_page: 4)
    end

    def item
        get_activities("gallery/v1/activities/#{params['id']}")
    end

    private

    def get_activities(url)
        result = ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        @activities = JSON.parse(result.body,symbolize_names:true)
    end

    def get_authors(url)
        result = ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        JSON.parse(result.body,symbolize_names:true)[:data]
    end
end
