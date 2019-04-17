class NetworkMapPluginMapController < PublicController

    def index
        @query = params[:query]
        @type = params[:type] || :people
        @scope = environment.send(@type).accessible_to(user)
        @searches = {}
        @searches[@type] = find_by_contents(@type, environment, @scope, @query, {page: 1, per_page: @scope.count})
        @searches[@type][:results] = @searches[@type][:results].select { |profile| profile.fields_privacy[:location] == "public" }
        @types = [
            [_('People'), :people],
            [_('Enterprises'), :enterprises],
            [_('Communities'), :communities]
        ]
    end
end
