module Refinery
  class I18nGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_refinery_i18n_initializer
      template "config/initializers/refinery/i18n.rb.erb",
               File.join(destination_root, "config", "initializers", "refinery", "i18n.rb")
      template "config/initializers/route_translator.rb.erb",
               File.join(destination_root, "config", "initializers", "route_translator.rb")
    end

  end
end
