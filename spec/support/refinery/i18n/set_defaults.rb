# encoding: utf-8

RSpec.configure do |config|
  config.before(:all) do
    Refinery::I18n.configure do |config|
      config.default_locale = :en

      config.current_locale = :en

      config.default_frontend_locale = :en

      config.frontend_locales = [:en]

      config.locales = {:en=>"English", :fr=>"Français", :nl=>"Nederlands", :"pt-BR"=>"Português", :da=>"Dansk", :nb=>"Norsk Bokmål", :sl=>"Slovenian", :es=>"Español", :ca=>"Català", :it=>"Italiano", :de=>"Deutsch", :lv=>"Latviski", :ru=>"Русский", :sv=>"Svenska", :pl=>"Polski", :"zh-CN"=>"Simplified Chinese", :"zh-TW"=>"Traditional Chinese", :el=>"Ελληνικά", :rs=>"Srpski", :cs=>"Česky", :sk=>"Slovenský", :ja=>"日本語", :bg=>"Български"}
    end
  end
end
