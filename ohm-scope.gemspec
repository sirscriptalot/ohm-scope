require './lib/ohm/scope'

Gem::Specification.new do |s|
  s.name     = 'ohm-scope'
  s.summary  = 'Ohm::Scope'
  s.version  = Ohm::Scope::VERSION
  s.authors  = ['Steve Weiss']
  s.email    = ['weissst@mail.gvsu.edu']
  s.homepage = 'https://github.com/sirscriptalot/ohm-scope'
  s.license  = 'MIT'
  s.files    = `git ls-files`.split("\n")

  s.add_dependency 'ohm', '~> 3.0'
end
