module Refinery
  class I18nGenerator < Rails::Generators::Base
    source_root File.expand_path('../../../', __FILE__)

    def generate
      copy_file 'config/i18n-js.yml', Rails.root.join('config', 'i18n-js.yml')
    end

  end
end