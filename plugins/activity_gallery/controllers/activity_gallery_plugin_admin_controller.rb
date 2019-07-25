class ActivityGalleryPluginAdminController < PluginAdminController

    def search_activities
        arg = params[:q].downcase
        result = ActivityGalleryPlugin::Request.get("gallery/v1/activities/?per=50", nil, nil)
        activities = JSON.parse(result.body,symbolize_names:true)[:data].
        map { |activity| ActivityGalleryPlugin::Activity.new(activity) }.
        select { |activity| activity.title.downcase.match(/#{arg}/) }
        render plain: prepare_to_token_input(activities).to_json
    end

end 

