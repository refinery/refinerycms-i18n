class RefinerycmsI18n < ::Refinery::Generators::EngineInstaller

  source_root File.expand_path('../../../', __FILE__)
  engine_name "i18n"

  def generate
    copy_file 'config/i18n-js.yml', Rails.root.join('config', 'i18n-js.yml')
  end

end