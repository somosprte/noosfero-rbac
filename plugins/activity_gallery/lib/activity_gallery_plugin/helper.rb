module ActivityGalleryPlugin::Helper

    def activity_actions(activity)
        [
            link_to(font_awesome(:edit, _('Edit')), '#'),
            link_to(font_awesome(:trash, _('Remove')), {controller: 'activity_gallery_plugin_activity', action: 'destroy', id: params[:id]}, {data: {confirm: _('Are you sure you want to remove this role?')}}),
            link_to(font_awesome(:spread, _('Spread')), '#'),
        ]
    end

end
