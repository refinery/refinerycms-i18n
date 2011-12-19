module Refinery
  module I18n
    include ActiveSupport::Configurable

    config_accessor :current_locale, :default_locale, :default_frontend_locale,
                    :enabled, :frontend_locales, :locales

    self.enabled = true
    self.default_locale = :en
    self.default_frontend_locale = self.default_locale
    self.current_locale = self.default_locale
    self.frontend_locales = [self.default_frontend_locale]
    self.locales = self.built_in_locales
  end
end
