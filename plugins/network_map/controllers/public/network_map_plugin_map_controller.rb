class NetworkMapPluginMapController < PublicController
    
    no_design_blocks

    def index
        @enterprise_kinds = environment.kinds.where(type: 'Enterprise')
        @query = params[:query]
        @type = params[:type] || :profiles
        @scope = environment.send(@type).accessible_to(user)
        @scope = @scope.joins(:kinds).where("kinds.name = '#{params[:kind]}'") if params[:kind].present?
        @searches = {}
        @searches[@type] = find_by_contents(@type, environment, @scope, @query, {page: 1, per_page: @scope.count})
        @searches[@type][:results] = @searches[@type][:results].select { |profile| profile.fields_privacy[:location] == "public" }
        @types = [
            [_('All'), :profiles],
            [_('People'), :people],
            [_('Enterprises'), :enterprises],
            [_('Communities'), :communities]
        ]
    end
end
