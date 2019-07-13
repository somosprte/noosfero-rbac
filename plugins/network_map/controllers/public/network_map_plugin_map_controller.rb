class NetworkMapPluginMapController < PublicController
    
    no_design_blocks
    helper_method :filter_profiles

    def index
        @enterprise_kinds = environment.kinds.where(type: 'Enterprise')
        @community_kinds = environment.kinds.where(type: 'Community')
        @query = params[:query]
        @types = params[:types] || []
        filter_profiles(@query, @types)
    end

    private

    def filter_profiles(query, types)
        @scope = environment.profiles.accessible_to(user).left_outer_joins(:kinds)
        type_conditions = types.map do |type|
            type, kind = type.split('_')
            conditions = ["profiles.type = '#{type.singularize.camelize}'"]
            conditions << "kinds.name = '#{kind}'" if kind.present?
            "(#{conditions.join(' AND ')})"
        end.join(' OR ')
        @scope = @scope.where(type_conditions) if types.present?
        @searches = {}
        type = 'all'
        @searches[type] = find_by_contents(type, environment, @scope, query, {page: 1, per_page: @scope.count})
        @searches[type][:results] = @searches[type][:results].select { |profile| profile.fields_privacy[:location] == "public" }
        return @searches[type][:results]
    end

end
