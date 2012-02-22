# Encoding: UTF-8 <-- required, please leave this in.
require 'refinerycms-core'
require 'routing-filter'

module Refinery
  autoload :I18nGenerator, 'generators/refinery/i18n_generator'

  module I18n
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

    require 'refinery/i18n/engine'
    require 'refinery/i18n/configuration'
  end
end
