# Routing Filter Rails Compatibility Fix
#
# Rails 7.1 changed from find_routes to recognize method in ActionDispatch::Journey::Router
# Rails 8.0 continued using recognize method
# Rails 8.1 may have additional changes
# This file provides compatible implementations for all versions.

# First, remove the old broken override if it exists
if defined?(ActionDispatchJourneyRouterWithFiltering) &&
   ActionDispatchJourneyRouterWithFiltering.method_defined?(:find_routes)
  ActionDispatchJourneyRouterWithFiltering.remove_method(:find_routes)
end

module RoutingFilterOverrideShared
  private def apply_routing_filters(path, env)
    filter_parameters = {}
    original_path = path.dup
    
    @routes.filters.run(:around_recognize, path, env) do
      filter_parameters
    end
    
    [path, original_path, filter_parameters]
  end
end

if Rails::VERSION::MAJOR == 8 && Rails::VERSION::MINOR >= 1
  # Rails 8.1+ uses recognize method with potential changes
  module CustomOverridesActionDispatchJourneyRouterRails81
    include RoutingFilterOverrideShared
    
    def recognize(req, &block)
      path, original_path, filter_parameters = apply_routing_filters(req.path_info, req.env)
      req.path_info = path
      
      super(req) do |route, parameters|
        parameters.merge!(filter_parameters)
        req.path_info = original_path
        yield route, parameters
      end.tap { req.path_info = original_path }
    end
  end
  
  ActionDispatch::Journey::Router.prepend(CustomOverridesActionDispatchJourneyRouterRails81)
elsif Rails::VERSION::MAJOR == 8 || (Rails::VERSION::MAJOR >= 7 && Rails::VERSION::MINOR >= 1)
  # Rails 7.1+ and Rails 8.0 use recognize method
  module CustomOverridesActionDispatchJourneyRouterRails71
    include RoutingFilterOverrideShared
    
    def recognize(req, &block)
      path, original_path, filter_parameters = apply_routing_filters(req.path_info, req.env)
      req.path_info = path
      
      super(req) do |route, parameters|
        parameters.merge!(filter_parameters)
        req.path_info = original_path
        yield route, parameters
      end.tap { req.path_info = original_path }
    end
  end
  
  ActionDispatch::Journey::Router.prepend(CustomOverridesActionDispatchJourneyRouterRails71)
else
  # Rails < 7.1 uses find_routes method
  module CustomOverridesActionDispatchJourneyRouterWithFiltering
    def find_routes(env)
      path = env.is_a?(Hash) ? env['PATH_INFO'] : env.path_info
      filter_parameters = {}
      original_path = path.dup

      @routes.filters.run(:around_recognize, path, env) do
        filter_parameters
      end

      super(env).map do |match, parameters, route|
        [ match, parameters.merge(filter_parameters), route ]
      end.tap do
        # restore the original path
        if env.is_a?(Hash)
          env['PATH_INFO'] = original_path
        else
          env.path_info = original_path
        end
      end
    end
  end
  
  ActionDispatch::Journey::Router.prepend(CustomOverridesActionDispatchJourneyRouterWithFiltering)
end
