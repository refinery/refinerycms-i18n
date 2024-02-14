Translate
=========

This plugin provides a web interface for translating Rails I18n texts (requires Rails 2.2 or higher) from one locale to another. The plugin has been tested only with the simple I18n backend that ships with Rails. I18n texts are read from and written to YAML files under `config/locales`.

To translate to a new locale you need to add a YAML file for that locale.
A translation file has the _locale_ as the top key and at least one translation.

Please note that there are certain I18n keys that map to Array objects rather than strings and those are currently not dealt with by the translation UI. This means that Rails built in keys such as date.day_names need to be translated manually directly in the YAML file.

To get the translation UI to write the YAML files in UTF8 you need to install the ya2yaml gem.

The translation UI finds all I18n keys by extracting them from I18n lookups in your application source code. In addition it adds all :en and default locale keys from the I18n backend.

- Updated: Each string in the UI now has an "Auto Translate" link which will send the original text to Google Translate and will input the returned translation into the form field for further clean up and review prior to saving.


Rake Tasks
=========

In addition to the web UI this plugin adds the following rake tasks:

* translate:lost_in_translation
* translate:merge_keys
* translate:google
* translate:changed

### Lost in Translation
The `translate:lost_in_translation` task shows you any I18n keys in your code that are do not have translations in the YAML file for your default locale, i.e. config/locales/sv.yml.

### Merge Keys
The `translate:merge_keys` task is supposed to be used in conjunction with Sven Fuch's [Rails I18n TextMate bundle](http://github.com/svenfuchs/rails-i18n/tree/master). 

Texts and keys extracted with the TextMate bundle end up in a temporary file `log/translations.yml`. 
When you run the `merge_keys` rake task these keys are moved to the corresponding I18n locale file, i.e. `config/locales/sv.yml`. 
The `merge_keys` task also warns you if one of your extracted keys will overwrite an existing translation.

### Translate Google
The `translate:google` task is used for auto translating from one locale to another using Google Translate.

### Translate Changed
The `translate:changed` task can show you which keys have had their texts changed between one file and another.

## Installation

Obtain the source with:

./script/plugin install git://github.com/newsdesk/translate.git

To mount the plugin, add the following to your config/routes.rb file:

Translate::Routes.translation_ui(map) if RAILS_ENV != "production"

Now visit /translate in your web browser to start translating.

Dependencies
=========

- Rails 2.2 or higher
- The ya2yaml gem if you want your YAML files written in UTF8 encoding.

Authors
=========

- Peter Marklund (programming)
- Joakim Westerlund (web design)

Many thanks to http://newsdesk.se for sponsoring the development of this plugin.

Copyright (c) 2009 Peter Marklund, released under the MIT license
