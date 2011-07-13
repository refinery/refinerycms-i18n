# Encoding: UTF-8 <-- required, please leave this in.
require 'refinerycms-core'
require 'routing-filter'

module Refinery
  module I18n
    class Engine < Rails::Engine
      config.before_initialize do
        require File.expand_path('../i18n-filter', __FILE__)
        require File.expand_path('../i18n-js', __FILE__)
        require File.expand_path('../translate', __FILE__)
      end

      initializer "configure fallbacks" do
        require "i18n/backend/fallbacks"
        if defined?(::I18n::Backend::Simple) && defined?(::I18n::Backend::Fallbacks)
          ::I18n::Backend::Simple.send(:include, ::I18n::Backend::Fallbacks)
        end
      end

      config.to_prepare do
        ::ApplicationController.module_eval do
          before_filter lambda {|c|
            ::SimplesIdeias::I18n.export! if Rails.env.development?
          }

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

        ::Admin::BaseController.class_eval do
          def find_or_set_locale
            if (params[:set_locale] and ::Refinery::I18n.locales.keys.map(&:to_sym).include?(params[:set_locale].to_sym))
              ::Refinery::I18n.current_locale = params[:set_locale].to_sym
              redirect_back_or_default(main_app.refinery_admin_root_path) and return
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

        ::Refinery::Plugin.register do |plugin|
          plugin.name = "refinery_i18n"
          plugin.version = %q{1.1.0}
          plugin.hide_from_menu = true
          plugin.always_allow_access = true
        end
      end

    end

    class << self

      attr_accessor :built_in_locales, :current_locale, :current_frontend_locale,
                    :default_locale, :default_frontend_locale, :enabled, :locales

      def enabled=(value)
        @enabled = Refinery::Setting.set(:i18n_translation_enabled, {
          :value => value,
          :scoping => 'refinery'
        })
      end

      def enabled?
        ::Refinery::Setting.find_or_set(:i18n_translation_enabled, true, {
          :scoping => 'refinery'
        })
      end

      def current_locale
        unless enabled?
          ::Refinery::I18n.current_locale = ::Refinery::I18n.default_locale
        else
          ::Refinery::Setting.find_or_set(:i18n_translation_current_locale, ::Refinery::I18n.default_locale, {
            :scoping => 'refinery'
          }).to_sym
        end
      end

      def current_locale=(locale)
        ::Refinery::Setting.set(:i18n_translation_current_locale, {
          :value => locale.to_sym,
          :scoping => 'refinery'
        })

        ::I18n.locale = locale.to_sym
      end

      def default_locale
        ::Refinery::Setting.find_or_set(:i18n_translation_default_locale, :en, {
          :scoping => 'refinery'
        }).to_sym
      end

      def current_frontend_locale
        if Globalize.locale.present? && Globalize.locale.to_s != ::Refinery::I18n.default_frontend_locale.to_s
          Globalize.locale
        elsif ::Refinery::I18n.default_frontend_locale.present?
          ::Refinery::I18n.default_frontend_locale
        else
          ::I18n.locale
        end
      end

      def default_frontend_locale
        ::Refinery::Setting.find_or_set(:i18n_translation_default_frontend_locale, :en, {
          :scoping => 'refinery'
        }).to_sym
      end

      def frontend_locales
        ::Refinery::Setting.find_or_set(:i18n_translation_frontend_locales, [self.default_frontend_locale], {
          :scoping => 'refinery'
        })
      end

      def locales
        ::Refinery::Setting.find_or_set(:i18n_translation_locales, self.built_in_locales, {
          :scoping => 'refinery'
        })
      end

      def has_locale?(locale)
        locales.has_key?(locale.try(:to_sym))
      end

      def setup!
        # TODO: Remove when enough time has passed (this was called in setting callbacks).
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
      :jp => '日本語',
      :bg => 'Български'
    }
  end
end

