class ActivityGalleryPluginActivityController < ProfileController

    no_design_blocks
    before_action :logged_user
    before_action :activity_authors, only: %i[edit destroy update]
    skip_before_action :logged_user, only: %i[index show]

    def index
        @activities = get("gallery/v1/activities/#{build_search_params}").
            map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
        @results = @activities.paginate(page: params[:page] || 1, per_page: 4)
    end

    def saved_activities
        @activities = get('gallery/v1/activities/?per=50')
        .map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
        .select { |activity| activity.favorited }
        @results = @activities.paginate(page: params[:page] || 1, per_page: 4)
    end

    def my_activities
        @activities = get('gallery/v1/activities/?per=50')
        .map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
        .select { |activity| activity.is_author?(user) }
        @results = @activities.paginate(page: params[:page] || 1, per_page: 4)
    end

    def show
        @activity = ActivityGalleryPlugin::Activity.new(get("gallery/v1/activities/#{params['id']}"))
        @page = @activity
    end

    def new
        @activity = ActivityGalleryPlugin::Activity.new
        @activity.authors = [{ id: session['activity_gallery_plugin_user_id'], name: user.name, email: user.email }]
    end

    def edit
        @activity = ActivityGalleryPlugin::Activity.new(get("gallery/v1/activities/#{params['id']}"))
        @page = @activity
    end

    def remix
        @activity = ActivityGalleryPlugin::Activity.new(get("gallery/v1/activities/#{params['id']}"))
        @activity.inspirations = [{ activity_two_id: params['id'], title: @activity.title }]
        @activity.title += ' (Remixada)'
        @activity.authors = [{ id: session['activity_gallery_plugin_user_id'], name: user.name, email: user.email }]
        @page = @activity
    end

    def implement
    end

    def create
        activity = ActivityGalleryPlugin::Activity.new({attributes: params[:data]})
        activity.ensure_author(session['activity_gallery_plugin_user_id'])
        result = create_activity(activity)
        redirect_to "/galeria/#{result[:id]}"
    end

    def create_remix
        activity = ActivityGalleryPlugin::Activity.new({attributes: params[:data]})
        activity.ensure_author(session['activity_gallery_plugin_user_id'])
        result = remix_activity(params[:id], activity)
        redirect_to "/galeria/#{result[:id]}"
    end

    def update
        activity = ActivityGalleryPlugin::Activity.new({attributes: params[:data]})
        activity.ensure_author(session['activity_gallery_plugin_user_id'])
        result = update_activity(params[:id], activity)
        redirect_to "/galeria/#{result[:id]}"
    end

    def send_implementation
        ActivityGalleryPlugin::Request.post("/gallery/v1/activities/#{params['id']}/implement", params[:implementation].to_h, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params[:id]}"
    end

    def destroy
        url = "/gallery/v1/activities/#{params['id']}"
        result = ActivityGalleryPlugin::Request.delete(url, nil, session['activity_gallery_plugin_jwt'])
        redirect_to '/galeria'
    end

    def toggle_like
        url = "/gallery/v1/activities/#{params['id']}/like"
        ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params['id']}"
    end

    def toggle_save
        url = "/gallery/v1/activities/#{params['id']}/favorite"
        ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params['id']}"
    end

    def search_authors
        arg = params[:q].downcase
        authors = get('user/v1/people')
        result = authors.select do |author|
            author[:attributes][:name].downcase.match(/#{arg}/).present?
        end.map {|author| {id: author[:id], name: author[:attributes][:name]}}
        render plain: result.to_json
    end

    def search_inspirations
        arg = params[:q].downcase
        @activities = get('gallery/v1/activities/?per=50')
        result = @activities.select do |activity|
            activity[:attributes][:title].downcase.match(/#{arg}/).present?
        end.map {|activity| {id: activity[:id], name: activity[:attributes][:title]}}
        render plain: result.to_json
    end

    private

    def build_search_params
        @search_params = {}
        @search_params["per"] = '50'
        @search_params["global"] = params["search"] if params["search"].present?
        @search_params["scope_ids"] = params["scopes"].join(',') if params["scopes"].present?
        @search_params["author_ids"] = params["authors"] if params["authors"].present?
        @search_params["audience_ids"] = params["audiences"].join(',') if params["audiences"].present?
        @search_params["space_type_ids"] = params["space_types"].join(',') if params["space_types"].present?

        '?' + @search_params.map do |key, value|
            "#{key}=#{value}"
        end.join('&')
    end

    def logged_user
        if !logged_in?
            session[:return_to] = {controller: params['controller'], action: params['action'], id: params['id']}
            redirect_to :controller => 'account', :action => 'login'
        end
    end

    def activity_authors
        activity = ActivityGalleryPlugin::Activity.new(get("gallery/v1/activities/#{params['id']}"))
        if !logged_in? || !activity.is_author?(user)
            session[:return_to] = {controller: params['controller'], action: params['action'], id: params['id']}
            session[:notice] = _('Você não tem autorização para executar essa ação')
            redirect_to '/galeria'
        end
    end

    def get(url)
        result = ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        JSON.parse(result.body,symbolize_names:true)[:data]
    end

    def create_activity(activity)
        result = ActivityGalleryPlugin::Request.post("gallery/v1/activities", activity.body, session['activity_gallery_plugin_jwt'])
        JSON.parse(result.body,symbolize_names:true)[:data]
    end

    def update_activity(id, activity)
        result = ActivityGalleryPlugin::Request.put("gallery/v1/activities/#{id}", activity.body, session['activity_gallery_plugin_jwt'])
        JSON.parse(result.body,symbolize_names:true)[:data]
    end

    def remix_activity(id, activity)
        result = ActivityGalleryPlugin::Request.post("gallery/v1/activities/#{id}/remix", activity.body, session['activity_gallery_plugin_jwt'])
        JSON.parse(result.body,symbolize_names:true)[:data]
    end
end
