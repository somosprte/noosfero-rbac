module ActivityGalleryPlugin::Helper

    def activity_actions(activity, user)
        actions = [
            link_to(font_awesome(:clone, _('Remixar')), "/galeria/remixar-atividade/#{params[:id]}")
        ]
        if activity.is_author?(user)
            actions += [
                link_to(font_awesome(:edit, _('Edit')), "/galeria/editar-atividade/#{params[:id]}"),
                link_to(font_awesome(:trash, _('Remove')), {controller: 'activity_gallery_plugin_activity', action: 'destroy', id: params[:id]}, {data: {confirm: _('Você tem certeza que deseja excluir essa atividade?')}}),
            ]
        end
        return actions
    end

    def activity_url
        "#{environment.top_url}/galeria/#{params[:id]}"
    end

    def build_search_params
        @search_params = {}
        @search_params["per"] = '50'
        @search_params["global"] = params["search"] if params["search"].present?
        @search_params["scope_ids"] = params["scopes"].join(',') if params["scopes"].present?
        @search_params["author_ids"] = params["authors"] if params["authors"].present?
        @search_params["audience_ids"] = params["audiences"].join(',') if params["audiences"].present?
        @search_params["license_ids"] = params["license"].join(',') if params["license"].present?
        @search_params["space_type_ids"] = params["space_types"].join(',') if params["space_types"].present?
        @search_params["order"] = params["order"] if params["order"].present?
        '?' + @search_params.map do |key, value|
            "#{key}=#{value}"
        end.join('&')
    end

    def get(url)
        result = ActivityGalleryPlugin::Request.get(url, nil, session['activity_gallery_plugin_jwt'])
        JSON.parse(result.body,symbolize_names:true)[:data]
    end

end
