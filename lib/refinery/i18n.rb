# Encoding: UTF-8 <-- required, please leave this in.
require 'refinerycms-core'
require 'routing-filter'

module Refinery
  module I18n
    include ActiveSupport::Configurable

    class << self
      attr_accessor :built_in_locales

      def built_in_locales
        @built_in_locales ||= {
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
          :ja => '日本語',
          :bg => 'Български'
        }
      end

      def current_frontend_locale
        if Globalize.locale.present? && Globalize.locale.to_s != config.default_frontend_locale.to_s
          Globalize.locale
        elsif config.default_frontend_locale.present?
          config.default_frontend_locale
        else
          ::I18n.locale
        end
      end

      def enabled?
        config.enabled
      end

      def has_locale?(locale)
        config.locales.has_key?(locale.try(:to_sym))
      end
    end

    config_accessor :current_locale, :default_locale, :default_frontend_locale,
                    :enabled, :frontend_locales, :locales

    self.enabled = true
    self.default_locale = :en
    self.default_frontend_locale = self.default_locale
    self.current_locale = self.default_locale
    self.frontend_locales = [self.default_frontend_locale]
    self.locales = self.built_in_locales

    require 'refinery/i18n/engine' if defined?(Rails)
  end
end

