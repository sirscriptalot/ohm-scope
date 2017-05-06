require './lib/ohm/filter'

Gem::Specification.new do |s|
  s.name     = 'ohm-filter'
  s.summary  = 'Ohm::Filter'
  s.version  = Ohm::Filter::VERSION
  s.authors  = ['Steve Weiss']
  s.email    = ['weissst@mail.gvsu.edu']
  s.homepage = 'https://github.com/sirscriptalot/ohm-filter'
  s.license  = 'MIT'
  s.files    = `git ls-files`.split("\n")

  s.add_dependency 'ohm', '~> 3.0'
end
