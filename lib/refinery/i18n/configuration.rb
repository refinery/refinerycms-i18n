module Refinery
  module I18n
    include ActiveSupport::Configurable

    config_accessor :current_locale, :default_locale, :default_frontend_locale,
                    :fallbacks_enabled, :frontend_locales, :locales,
                    :url_filter_enabled

    self.default_locale = :en
    self.default_frontend_locale = self.default_locale
    self.current_locale = self.default_locale
    self.fallbacks_enabled = true
    self.frontend_locales = [self.default_frontend_locale]
    self.locales = self.built_in_locales
    self.url_filter_enabled = true

    def self.frontend_locales
      config.frontend_locales.select do |locale|
        config.locales.keys.map(&:to_s).include?(locale.to_s)
      end
    end
  end
end
