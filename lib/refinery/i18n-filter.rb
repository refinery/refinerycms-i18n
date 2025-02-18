module RoutingFilter
  class RefineryLocales < Filter

    def around_recognize(path, env, &block)
      if ::Refinery::I18n.url_filter_enabled?
        if path =~ %r{^/(#{::Refinery::I18n.locales.keys.join('|')})(/|$)}
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
        params[:locale] = ::I18n.locale.to_s
      end
    end

    def around_generate(params, &block)
      locale = params.delete(:locale) || ::I18n.locale

      yield.tap do |result|
        result = result.is_a?(Array) ? result.first : result
        insert_locale(result.url, locale) if url_needs_locale?(result.url, locale)
      end
    end

    private
    # locale should be inserted if filtering AND not in default locale AND not a backend url
    def url_needs_locale?(url, locale)
      ::Refinery::I18n.url_filter_enabled? and
        locale != ::Refinery::I18n.default_frontend_locale  and
        url !~ %r{(#{Refinery::Core.backend_route}|wymiframe)}
    end

    def insert_locale(url, locale)
      url.sub!(%r(^(http.?://[^/]*)?(.*))) { "#{$1}/#{locale}#{$2}" }
    end
  end
end
