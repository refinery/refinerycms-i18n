module Refinery
  module I18n
    include ActiveSupport::Configurable

    config_accessor :current_locale, :default_locale, :default_frontend_locale,
                    :enabled, :fallbacks_enabled, :frontend_locales, :locales,
                    :url_filter_enabled, :domain_name_enabled, :domains_locales

    self.enabled = true
    self.default_locale = :en
    self.default_frontend_locale = self.default_locale
    self.current_locale = self.default_locale
    self.fallbacks_enabled = true
    self.frontend_locales = [self.default_frontend_locale]
    self.locales = self.built_in_locales
    self.url_filter_enabled = true
    self.domain_name_enabled = false
    self.domains_locales = {"www.mysite.com"=>:en, "www.mon-site.fr"=>:fr}
  end
end
