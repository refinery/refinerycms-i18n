require 'refinery'

module Refinery
  module I18n
    class Engine < Rails::Engine
      config.to_prepare do
        ::Refinery::I18n.setup! if defined?(RefinerySetting) and RefinerySetting.table_exists?
      end
    end
  end
end