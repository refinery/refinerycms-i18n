module RoutingFilter
  class RefineryLocales < Filter

    def around_recognize(path, env, &block)
      if ::Refinery::I18n.url_filter_enabled? || ::Refinery::I18n.domain_name_enabled?
        if ::Refinery::I18n.domain_name_enabled?
          hostname = env['HTTP_HOST'].sub(/:\d+$/, '')
          ::I18n.locale = ::Refinery::I18n.domains_locales[hostname] || ::Refinery::I18n.default_frontend_locale
        elsif path =~ %r{^/(#{::Refinery::I18n.locales.keys.join('|')})(/|$)}
          path.sub! %r(^/(([a-zA-Z\-_])*)(?=/|$)) do
            ::I18n.locale = $1
            ''
          end
          path.sub!(%r{^$}) { '/' }
        else
          ::I18n.locale = ::Refinery::I18n.default_frontend_locale
        end
      end

      yield.tap do |params|
        params[:locale] = ::I18n.locale if ::Refinery::I18n.enabled?
      end
    end

    def around_generate(params, &block)
      locale = params.delete(:locale) || ::I18n.locale

      yield.tap do |result|
        result = result.is_a?(Array) ? result.first : result
        if ::Refinery::I18n.url_filter_enabled? and !::Refinery::I18n.domain_name_enabled? and
           locale != ::Refinery::I18n.default_frontend_locale and
           result !~ %r{^/(#{Refinery::Core.backend_route}|wymiframe)}
          result.sub!(%r(^(http.?://[^/]*)?(.*))) { "#{$1}/#{locale}#{$2}" }
        end
      end
    end

  end
end
