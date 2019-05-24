module ActivityGalleryPlugin::Helper

    def activity_actions
        [
            link_to(font_awesome(:edit, _('Edit')), "/galeria/editar-atividade/#{params[:id]}"),
            link_to(font_awesome(:clone, _('Remixar')), "/galeria/remixar-atividade/#{params[:id]}"),
            link_to(font_awesome(:trash, _('Remove')), {controller: 'activity_gallery_plugin_activity', action: 'destroy', id: params[:id]}, {data: {confirm: _('Você tem certeza que deseja excluir essa atividade?')}}),
        ]
    end

    def activity_url
        "#{environment.top_url}/galeria/#{params[:id]}"
    end

end
