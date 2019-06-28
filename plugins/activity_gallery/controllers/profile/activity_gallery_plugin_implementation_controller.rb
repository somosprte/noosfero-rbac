class ActivityGalleryPluginImplementationController < ProfileController

    def new
    end
        
    def create
        params[:implementation][:person_ids] ||= ''
        params[:implementation][:person_ids] = params[:implementation][:person_ids].split(',')
        result = ActivityGalleryPlugin::Request.post("/gallery/v1/activities/#{params[:activity_id]}/implement", params[:implementation].to_h, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params[:activity_id]}"
    end

    def edit
        @implementation = params[:implementation]
    end

    def update
        params[:implementation][:person_ids] ||= ''
        params[:implementation][:person_ids] = params[:implementation][:person_ids].split(',')
        params[:implementation][:date_implementation] = Date.parse(params[:implementation][:date_implementation]).strftime('%F')
        url = "/experience/v1/implementations/#{params[:id]}"
        body = {'implementation' => params[:implementation].to_h}
        result = ActivityGalleryPlugin::Request.put(url, body, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params[:activity_id]}"
    end

    def destroy
        url = "/experience/v1/implementations/#{params[:id]}"
        result = ActivityGalleryPlugin::Request.delete(url, nil, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params[:activity_id]}"
    end

end