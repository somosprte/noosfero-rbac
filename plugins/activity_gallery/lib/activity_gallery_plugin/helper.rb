module ActivityGalleryPlugin::Helper

    def activity_actions
        [
            link_to(font_awesome(:edit, _('Edit')), '#'),
            link_to(font_awesome(:trash, _('Remove')), {controller: 'activity_gallery_plugin_activity', action: 'destroy', id: params[:id]}, {data: {confirm: _('Você tem certeza que deseja excluir essa atividade?')}}),
            # link_to(font_awesome(:spread, _('Spread')), '#'),
        ]
    end

    def activity_url
        "#{environment.top_url}/galeria/item?id=#{params[:id]}"
    end

end
