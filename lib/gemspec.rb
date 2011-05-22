#!/usr/bin/env ruby
version = '1.1.0'
raise "Could not get version so gemspec can not be built" if version.nil?
files = Dir.glob("**/*").flatten.reject do |file|
  file =~ /\.gem(spec)?$/
end

gemspec = <<EOF
Gem::Specification.new do |s|
  s.name              = %q{refinerycms-i18n}
  s.version           = %q{#{version}}
  s.description       = %q{i18n logic extracted from RefineryCMS, for Refinery CMS.}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{i18n logic for Refinery CMS.}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.authors           = ['Philip Arndt']
  s.require_paths     = %w(lib)

  s.add_dependency    'refinerycms-core', '~> 1.1.0'
  s.add_dependency    'routing-filter', '>= 0.2.3'

  s.files             = [
    '#{files.sort.join("',\n    '")}'
  ]
  #{"s.test_files        = [
    '#{Dir.glob("test/**/*.rb").join("',\n    '")}'
  ]" if File.directory?("test")}
end
EOF

File.open(File.expand_path("../../refinerycms-i18n.gemspec", __FILE__), 'w').puts(gemspec)
