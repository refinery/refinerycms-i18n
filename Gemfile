source 'https://rubygems.org'

gemspec

git 'git://github.com/refinery/refinerycms.git', :branch => 'master' do
  gem 'refinerycms'

  group :development, :test do
    gem 'refinerycms-testing'
  end
end

group :development, :test do
  require 'rbconfig'

  # Database Configuration
  unless ENV['TRAVIS']
    gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
    gem 'sqlite3', :platform => :ruby
  end

  if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
    gem 'activerecord-jdbcmysql-adapter', :platform => :jruby
    gem 'jdbc-mysql', '= 5.1.13', :platform => :jruby
    gem 'mysql2', :platform => :ruby
  end

  if !ENV['TRAVIS'] || ENV['DB'] == 'postgresql'
    gem 'activerecord-jdbcpostgresql-adapter', :platform => :jruby
    gem 'pg', :platform => :ruby
  end

  platforms :mswin, :mingw do
    gem 'win32console'
    gem 'rb-fchange', '~> 0.0.5'
    gem 'rb-notifu', '~> 0.0.4'
  end

  platforms :ruby do
    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'rb-fsevent', '>= 0.3.9'
        gem 'growl',      '~> 1.0.3'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
        gem 'therubyracer', '~> 0.9.9'
      end
    end
  end

  platforms :jruby do
    unless ENV['TRAVIS']
      if RbConfig::CONFIG['target_os'] =~ /darwin/i
        gem 'growl',      '~> 1.0.3'
      end
      if RbConfig::CONFIG['target_os'] =~ /linux/i
        gem 'rb-inotify', '>= 0.5.1'
        gem 'libnotify',  '~> 0.1.3'
      end
    end
  end
end

# Refinery/rails should pull in the proper versions of these
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'
