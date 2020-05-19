require_relative "lib/pexels/version"

Gem::Specification.new do |s|
  s.name        = 'pexels'
  s.version     = Pexels::VERSION
  s.summary     = 'A simple Ruby wrapper for the Pexels API'
  s.description = 'See more details at https://www.pexels.com/api/documentation/'
  s.authors     = ['Pexels dev team']
  s.email       = ['api@pexels.com']
  s.homepage    = 'https://github.com/pexels/pexels-ruby'
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")

  s.add_dependency('requests', '~> 1.0.2')
end
