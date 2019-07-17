class ActivityGalleryPluginCommentController < PublicController

    def create
        ActivityGalleryPlugin::Request.post("/gallery/v1/activities/#{params[:activity_id]}/comment", params[:comment].to_h, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params[:activity_id]}"
    end

    def edit
        @comment = params[:comment]
        @activity_id = params[:activity_id]
    end

    def update
        url = "/experience/v1/comments/#{params[:id]}"
        body = {'comment' => params[:comment].to_h}
        result = ActivityGalleryPlugin::Request.put(url, body, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params[:activity_id]}"
    end

    def destroy
        url = "/experience/v1/comments/#{params[:id]}"
        result = ActivityGalleryPlugin::Request.delete(url, nil, session['activity_gallery_plugin_jwt'])
        redirect_to "/galeria/#{params[:activity_id]}"
    end

end