Gem::Specification.new do |s|
  s.name              = %q{refinerycms-i18n}
  s.version           = %q{2.0.2}
  s.description       = %q{i18n logic extracted from Refinery CMS, for Refinery CMS.}
  s.date              = %q{2012-08-03}
  s.summary           = %q{i18n logic for Refinery CMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = ['Philip Arndt']
  s.require_paths     = %w(lib)

  s.add_dependency    'refinerycms-core', '~> 2.0.0'
  s.add_dependency    'routing-filter',   '>= 0.2.3'

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")
end
