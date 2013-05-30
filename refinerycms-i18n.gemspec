Gem::Specification.new do |s|
  s.name              = %q{refinerycms-i18n}
  s.version           = %q{2.1.0.dev}
  s.description       = %q{i18n logic extracted from Refinery CMS, for Refinery CMS.}
  s.date              = %q{2012-02-29}
  s.summary           = %q{i18n logic for Refinery CMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = ['Philip Arndt']
  s.require_paths     = %w(lib)

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- spec/*`.split("\n")

  s.add_dependency    'routing-filter',   '~> 0.3.0'
  s.add_dependency    'rails-i18n',       '~> 0.7.3'
end
