module Refinery
  class I18nGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_refinery_i18n_initializer
      template "config/initializers/refinery_i18n.rb.erb", File.join(destination_root, "config", "initializers", "refinery_i18n.rb")
    end

    def generate_i18n_js
      template "config/i18n-js.yml", File.join(destination_root, "config", "i18n-js.yml")
    end
  end
end
