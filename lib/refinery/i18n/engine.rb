module Refinery
  module I18n
    class Engine < Rails::Engine
      config.before_initialize do
        require File.expand_path('../../i18n-filter', __FILE__)
        require File.expand_path('../../translate', __FILE__)
      end

      initializer "configure fallbacks" do
        if ::Refinery::I18n.fallbacks_enabled
          require "i18n/backend/fallbacks"
          if defined?(::I18n::Backend::Simple) && defined?(::I18n::Backend::Fallbacks)
            ::I18n::Backend::Simple.send(:include, ::I18n::Backend::Fallbacks)
          end
        end
      end

      config.to_prepare do
        ::ApplicationController.module_eval do
          def default_url_options(options={})
            ::Refinery::I18n.enabled? ? { :locale => ::I18n.locale } : {}
          end

          def find_or_set_locale
            if ::Refinery::I18n.enabled?
              ::I18n.locale = ::Refinery::I18n.current_frontend_locale

              if ::Refinery::I18n.has_locale?(locale = params[:locale].try(:to_sym))
                ::I18n.locale = locale
              elsif locale.present? and locale != ::Refinery::I18n.default_frontend_locale
                params[:locale] = ::I18n.locale = ::Refinery::I18n.default_frontend_locale
                redirect_to(params, :notice => "The locale '#{locale}' is not supported.") and return
              else
                ::I18n.locale = ::Refinery::I18n.default_frontend_locale
              end
              Thread.current[:globalize_locale] = ::I18n.locale
            end
          end

          prepend_before_filter :find_or_set_locale
          protected :default_url_options, :find_or_set_locale
        end

        ::Refinery::AdminController.class_eval do
          def find_or_set_locale
            if (params[:set_locale] and ::Refinery::I18n.locales.keys.map(&:to_sym).include?(params[:set_locale].to_sym))
              ::Refinery::I18n.current_locale = params[:set_locale].to_sym
              redirect_back_or_default(refinery.admin_root_path) and return
            else
              ::I18n.locale = ::Refinery::I18n.current_locale
            end
          end

          def globalize!
            if ::Refinery::I18n.frontend_locales.any?
              if params[:switch_locale]
                Thread.current[:globalize_locale] = params[:switch_locale].to_sym
              elsif ::I18n.locale != ::Refinery::I18n.default_frontend_locale
                Thread.current[:globalize_locale] = ::Refinery::I18n.default_frontend_locale
              end
            end

            Thread.current[:globalize_locale] = ::I18n.locale if Thread.current[:globalize_locale].nil?
          end
          # globalize! should be prepended first so that it runs after find_or_set_locale
          prepend_before_filter :globalize!, :find_or_set_locale
          protected :globalize!, :find_or_set_locale
        end
      end

      config.after_initialize do
        ::Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_i18n"
          plugin.version = %q{2.0.0}
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
        end
      end

    end
  end
end
