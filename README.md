# Refinery CMS I18n [![Build Status](https://travis-ci.org/refinery/refinerycms-i18n.svg?branch=master)](https://travis-ci.org/refinery/refinerycms-i18n)

I18n logic extracted from Refinery CMS, for Refinery CMS.

```ruby
gem 'refinerycms-i18n', '~> 4.0.1'
bundle install
rails g refinery:i18n
```

```ruby
Refinery::I18n.configure do |config|
   config.default_locale = :en

  # config.current_locale = :en

  # config.default_frontend_locale = :en

   config.frontend_locales = [:en,:ar]

   config.locales = {:en=>"English", :ar=>"Arabic"}
   #, :nl=>"Nederlands", :pt=>"Português", :"pt-BR"=>"Português brasileiro", :da=>"Dansk", :nb=>"Norsk Bokmål", :sl=>"Slovenian", :es=>"Español", :it=>"Italiano", :de=>"Deutsch", :lv=>"Latviski", :ru=>"Русский", :sv=>"Svenska", :pl=>"Polski", :"zh-CN"=>"简体中文", :"zh-TW"=>"繁體中文", :el=>"Ελληνικά", :rs=>"Srpski", :cs=>"Česky", :sk=>"Slovenský", :ja=>"日本語", :bg=>"Български", :hu=>"Hungarian", :uk=>"Українська"}
end
```
