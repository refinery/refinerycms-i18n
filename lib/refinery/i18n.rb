# Encoding: UTF-8 <-- required, please leave this in.
require 'refinerycms-core'
require 'routing-filter'
require 'rails-i18n'

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
          :pt => 'Português',
          :'pt-BR' => 'Português brasileiro',
          :da => 'Dansk',
          :nb => 'Norsk Bokmål',
          :sl => 'Slovenian',
          :es => 'Español',
          :ca => 'Català',
          :it => 'Italiano',
          :de => 'Deutsch',
          :lv => 'Latviski',
          :ru => 'Русский',
          :sv => 'Svenska',
          :pl => 'Polski',
          :'zh-CN' => '简体中文',
          :'zh-TW' => '繁體中文',
          :el => 'Ελληνικά',
          :rs => 'Srpski',
          :cs => 'Česky',
          :sk => 'Slovenský',
          :ja => '日本語',
          :bg => 'Български',
          :hu => 'Hungarian',
          :uk => 'Українська'
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

      def url_filter_enabled?
        config.url_filter_enabled
      end

      def has_locale?(locale)
        config.locales.has_key?(locale.try(:to_sym))
      end
    end

    require 'refinery/i18n/engine'
    require 'refinery/i18n/configuration'
  end
end
