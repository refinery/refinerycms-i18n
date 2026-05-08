#!/usr/bin/env rake
require "bundler/gem_helper"

Bundler::GemHelper.install_tasks(name: "refinerycms-i18n")

ENGINE_PATH = File.dirname(__FILE__)
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

load 'rails/tasks/engine.rake' if File.exist?(APP_RAKEFILE)

require "refinerycms-testing"
Refinery::Testing::Railtie.load_dummy_tasks(ENGINE_PATH)

load File.expand_path('../tasks/rspec.rake', __FILE__)

task :default => :spec
