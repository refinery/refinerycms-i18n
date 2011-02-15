# Encoding: UTF-8 <-- required, please leave this in.
if defined?(Refinery) && Refinery.version > '0.9.9'
  require 'refinerycms-core'
else
  require 'refinery'
end
require 'routing-filter'

module Refinery
  module I18n
    class Engine < Rails::Engine
      config.before_initialize do
        require File.expand_path('../i18n-filter', __FILE__)
        require File.expand_path('../i18n-js', __FILE__)
        require File.expand_path('../translate', __FILE__)
      end

      initializer "serve static assets" do |app|
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public"
      end

      config.to_prepare do
        ::ApplicationController.class_eval do
          def default_url_options(options={})
            ::Refinery::I18n.enabled? ? { :locale => ::I18n.locale } : {}
          end

          def find_or_set_locale
            if ::Refinery::I18n.enabled?
              ::I18n.locale = ::Refinery::I18n.current_locale

              if ::Refinery::I18n.has_locale?(locale = params[:locale].try(:to_sym))
                Thread.current[:globalize_locale] = locale
              elsif locale.present? and locale != ::Refinery::I18n.default_frontend_locale
                params[:locale] = Thread.current[:globalize_locale] = ::Refinery::I18n.default_frontend_locale
                redirect_to(params, :notice => "The locale '#{locale}' is not supported.") and return
              else
                Thread.current[:globalize_locale] = ::Refinery::I18n.default_frontend_locale
              end
            end
          end

          prepend_before_filter :find_or_set_locale
          protected :default_url_options, :find_or_set_locale
        end

        ::Admin::BaseController.class_eval do
          def find_or_set_locale
            if (params[:set_locale] and ::Refinery::I18n.locales.keys.map(&:to_sym).include?(params[:set_locale].to_sym))
              ::Refinery::I18n.current_locale = params[:set_locale].to_sym
              redirect_back_or_default(admin_root_path) and return
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
        ::Refinery::I18n.setup!

        Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_i18n"
          plugin.version = %q{0.9.9.11}
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
        end
      end

    end

    class << self

      attr_accessor :built_in_locales, :current_locale, :current_frontend_locale,
                    :default_locale, :default_frontend_locale, :enabled, :locales

      def enabled?
        RefinerySetting.find_or_set(:i18n_translation_enabled, true, {
          :scoping => 'refinery'
        })
      end

      def current_locale
        unless enabled?
          ::Refinery::I18n.current_locale = ::Refinery::I18n.default_locale
        else
          RefinerySetting.find_or_set(:i18n_translation_current_locale, ::Refinery::I18n.default_locale, {
            :scoping => 'refinery'
          }).to_sym
        end
      end

      def current_locale=(locale)
        value = {
          :value => locale.to_sym,
          :scoping => 'refinery'
        }
        # handles a change in Refinery API
        if RefinerySetting.methods.map(&:to_sym).include?(:set)
          RefinerySetting.set(:i18n_translation_current_locale, value)
        else
          RefinerySetting[:i18n_translation_current_locale] = value
        end

        ::I18n.locale = locale.to_sym
      end

      def default_locale
        RefinerySetting.find_or_set(:i18n_translation_default_locale, :en, {
          :scoping => 'refinery'
        }).to_sym
      end

      def current_frontend_locale
        if Thread.current[:globalize_locale].present?
          if Thread.current[:globalize_locale].to_s != ::Refinery::I18n.default_frontend_locale.to_s
            Thread.current[:globalize_locale]
          else
            ::Refinery::I18n.default_frontend_locale
          end
        elsif ::I18n.locale.present? && ::I18n.locale.to_s != ::Refinery::I18n.default_frontend_locale.to_s
          ::I18n.locale
        elsif ::Refinery::I18n.default_frontend_locale.present?
          ::Refinery::I18n.default_frontend_locale
        else
          ::I18n.locale
        end
      end

      def default_frontend_locale
        RefinerySetting.find_or_set(:i18n_translation_default_frontend_locale, :en, {
          :scoping => 'refinery'
        }).to_sym
      end

      def frontend_locales
        RefinerySetting.find_or_set(:i18n_translation_frontend_locales, [self.default_frontend_locale], {
          :scoping => 'refinery'
        })
      end

      def locales
        RefinerySetting.find_or_set(:i18n_translation_locales, self.built_in_locales, {
          :scoping => 'refinery'
        })
      end

      def has_locale?(locale)
        locales.has_key?(locale.try(:to_sym))
      end

      def setup!
        self.ensure_locales_up_to_date!
      end

      def ensure_locales_up_to_date!
        # ensure running latest locales (this is awfully brittle).
        locales = if Refinery.version >= '0.9.9'
          RefinerySetting.get(:i18n_translation_locales, :scoping => 'refinery')
        else
          RefinerySetting.find_by_name_and_scoping('i18n_translation_locales', 'refinery').try(:value)
        end

        if locales.present? and locales.is_a?(Hash) and locales.keys.exclude?(self.built_in_locales.keys.last)
          value = {:value => locales.dup.deep_merge(self.built_in_locales), :scoping => 'refinery'}
          if RefinerySetting.respond_to?(:set)
            RefinerySetting.set(:i18n_translation_locales, value)
          else
            RefinerySetting[:i18n_translation_locales] = value
          end
        end
      end

    end

    @built_in_locales = {
      :en => 'English',
      :fr => 'Français',
      :nl => 'Nederlands',
      :'pt-BR' => 'Português',
      :da => 'Dansk',
      :nb => 'Norsk Bokmål',
      :sl => 'Slovenian',
      :es => 'Español',
      :it => 'Italiano',
      :de => 'Deutsch',
      :lv => 'Latviski',
      :ru => 'Русский',
      :sv => 'Svenska',
      :pl => 'Polski',
      :'zh-CN' => 'Simplified Chinese',
      :'zh-TW' => 'Traditional Chinese',
      :el => 'Ελληνικά',
      :rs => 'Srpski',
      :cs => 'Česky',
      :sk => 'Slovenský',
      :jp => '日本語'
    }
  end
end

