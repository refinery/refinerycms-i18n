# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = %q{refinerycms-i18n}
  s.version           = %q{5.0.1}
  s.description       = %q{i18n logic extracted from Refinery CMS, for Refinery CMS.}
  s.summary           = %q{i18n logic for Refinery CMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{https://refinerycms.com}
  s.authors           = ['Philip Arndt', 'Uģis Ozols', 'Brice Sanchez']
  s.require_paths     = %w(lib)
  s.license           = %q{MIT}

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.required_ruby_version = '>= 2.2.9'

  s.add_dependency    'routing-filter',   '~> 0.4'
  s.add_dependency    'rails-i18n',       '>= 5.0'
  s.add_dependency    'mobility',         '~> 0.8.8'

  s.cert_chain  = [File.expand_path("../certs/parndt.pem", __FILE__)]
  if $0 =~ /gem\z/ && ARGV.include?("build") && ARGV.include?(__FILE__)
    s.signing_key = File.expand_path("~/.ssh/gem-private_key.pem")
  end
end
