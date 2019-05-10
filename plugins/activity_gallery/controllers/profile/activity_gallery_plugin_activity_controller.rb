class ActivityGalleryPluginActivityController < ProfileController

    before_action :logged_user

    def search_authors
        arg = params[:q].downcase
        authors = get_authors('user/v1/people')
        result = authors.select do |author|
            author[:attributes][:name].downcase.match(/#{arg}/).present?
        end.map {|author| {id: author[:id], name: author[:attributes][:name]}}
        render plain: result.to_json
    end

    # def search_activities
    #     arg = params[:q].downcase
    #     activities = get_activities('gallery/v1/activities/?per=50')
    #     result = activities.select do |activity|
    #         activity[:attributes][:title].downcase.match(/#{arg}/).present?
    #     end.map {|activity| {title: activity[:attributes][:title]}}
    # end

    def list
        if params[:search]
        get_activities("gallery/v1/activities?global=#{params[:search]}")
        else
        get_activities('gallery/v1/activities/?per=50')
        end
        @results = @activities[:data].paginate(page: params[:page] || 1, per_page: 4)
    end

    def item
        get_activities("gallery/v1/activities/#{params['id']}")
    end

    private

    def logged_user
        if !logged_in?
            session[:return_to] = {controller: params['controller'], action: params['action'], id: params['id']}
            redirect_to :controller => 'account', :action => 'login'
        end
    end

    def get_activities(url)
        result = ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        @activities = JSON.parse(result.body,symbolize_names:true)
    end

    def get_authors(url)
        result = ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        JSON.parse(result.body,symbolize_names:true)[:data]
    end
end
