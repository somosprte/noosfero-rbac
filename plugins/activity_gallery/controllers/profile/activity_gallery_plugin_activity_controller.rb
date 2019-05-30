class ActivityGalleryPluginActivityController < ProfileController

    no_design_blocks
    before_action :logged_user
    before_action :activity_authors, only: %i[edit destroy update]
    skip_before_action :logged_user, only: %i[index show]

    def index
        @activities = if params[:search]
            get("gallery/v1/activities?global=#{params[:search]}")
        else
            get('gallery/v1/activities/?per=50')
        end.map { |activity| ActivityGalleryPlugin::Activity.new(activity) }
        @results = @activities.paginate(page: params[:page] || 1, per_page: 4)
    end

    def show
        @activity = ActivityGalleryPlugin::Activity.new(get("gallery/v1/activities/#{params['id']}"))
        @page = @activity
    end

    def new
        @activity = ActivityGalleryPlugin::Activity.new
    end

    def edit
        @activity = ActivityGalleryPlugin::Activity.new(get("gallery/v1/activities/#{params['id']}"))
        @page = @activity
    end

    def remix
        @activity = ActivityGalleryPlugin::Activity.new(get("gallery/v1/activities/#{params['id']}"))
        @activity.title += ' Remixada'
        # @activity.inspirations = [params['id']]
        @page = @activity
    end

    def create
        activity = ActivityGalleryPlugin::Activity.new({attributes: params[:data]})
        result = create_activity(activity)
        redirect_to "/galeria/#{result[:id]}"
    end

    def update
        activity = ActivityGalleryPlugin::Activity.new({attributes: params[:data]})
        result = update_activity(params[:id], activity)
        redirect_to "/galeria/#{result[:id]}"
    end

    def destroy
        url = "/gallery/v1/activities/#{params['id']}"
        result = ActivityGalleryPlugin::Request.delete(url, nil, session['activity_gallery_plugin_jwt'])
        redirect_to '/galeria'
    end

    def like
        url = "/gallery/v1/activities/#{params['id']}/like"
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
end
