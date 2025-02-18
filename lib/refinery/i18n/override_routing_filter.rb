# from: https://github.com/svenfuchs/routing-filter/pull/87
# Removing the (existing) broken find_routes override from the routing-filter gem first
ActionDispatchJourneyRouterWithFiltering.remove_method(:find_routes)

module CustomOverridesActionDispatchJourneyRouterWithFiltering
  def find_routes(env)
    path = env.is_a?(Hash) ? env['PATH_INFO'] : env.path_info
    filter_parameters = {}
    original_path = path.dup

    @routes.filters.run(:around_recognize, path, env) do
      filter_parameters
    end

    ##### OVERRIDE STARTS #####
    super(env) do |match, parameters, route|
      parameters = parameters.merge(filter_parameters)

      if env.is_a?(Hash)
        env['PATH_INFO'] = original_path
      else
        env.path_info = original_path
      end

      yield [match, parameters, route]
    end
    ##### OVERRIDE ENDS #####
  end
end

ActionDispatch::Journey::Router.send(:prepend, CustomOverridesActionDispatchJourneyRouterWithFiltering)
