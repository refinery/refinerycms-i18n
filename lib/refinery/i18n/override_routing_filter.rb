# from: https://github.com/svenfuchs/routing-filter/pull/87
# Removing the (existing) broken find_routes override from the routing-filter gem first
if defined?(ActionDispatchJourneyRouterWithFiltering) &&
   ActionDispatchJourneyRouterWithFiltering.method_defined?(:find_routes)
  ActionDispatchJourneyRouterWithFiltering.remove_method(:find_routes)
end

module RoutingFilterOverrideShared
  private

  def apply_routing_filters(path, env)
    filter_parameters = {}
    original_path = path.dup

    @routes.filters.run(:around_recognize, path, env) do
      filter_parameters
    end

    [path, original_path, filter_parameters]
  end
end

if Rails::VERSION::MAJOR == 8 && Rails::VERSION::MINOR >= 1
  # Rails 8.1+ uses recognize method instead of find_routes
  module CustomOverridesActionDispatchJourneyRouterRails8
    include RoutingFilterOverrideShared

    def recognize(req, &block)
      path, original_path, filter_parameters = apply_routing_filters(req.path_info, req.env)
      req.path_info = path

      ##### OVERRIDE STARTS #####
      super(req) do |route, parameters|
        parameters.merge!(filter_parameters)
        req.path_info = original_path
        yield route, parameters
      end.tap { req.path_info = original_path }
      ##### OVERRIDE ENDS #####
    end
  end

  ActionDispatch::Journey::Router.prepend(CustomOverridesActionDispatchJourneyRouterRails8)
else
  # Rails < 8.1 uses find_routes method
  module CustomOverridesActionDispatchJourneyRouterWithFiltering
    include RoutingFilterOverrideShared

    def find_routes(env)
      path = env.is_a?(Hash) ? env['PATH_INFO'] : env.path_info
      path, original_path, filter_parameters = apply_routing_filters(path, env)

      ##### OVERRIDE STARTS #####
      super(env) do |match, parameters, route|
        parameters = parameters.merge(filter_parameters)
        env.is_a?(Hash) ? env['PATH_INFO'] = original_path : env.path_info = original_path
        yield [match, parameters, route]
      end
      ##### OVERRIDE ENDS #####
    end
  end

  ActionDispatch::Journey::Router.prepend(CustomOverridesActionDispatchJourneyRouterWithFiltering)
end
