class NetworkMapPluginMapController < PublicController

    def index
        @query = params[:query]
        @type = params[:type] || :people
        # @searches = {map: {results: environment.send(@type)}}
        @scope = environment.send(@type).accessible_to(user).visible
        @searches = {}
        @searches[@type] = find_by_contents(@type, environment, @scope, @query)
        @types = [
            [_('People'), :people],
            [_('Enterprises'), :enterprises],
            [_('Communities'), :communities]
        ]
    end
end
