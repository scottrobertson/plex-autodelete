Gem::Specification.new do |s|
  s.name        = 'plex-autodelete'
  s.version     = '0.0.2'
  s.date        = '2014-11-29'
  s.summary     = "Automatically removed watched episodes in Plex"
  s.description = "Automatically removed watched episodes in Plex"
  s.authors     = ["Scott Robertson"]
  s.email       = 'scottymeuk@gmail.com'
  s.files       = ["lib/plex-autodelete.rb"]
  s.homepage    = 'http://rubygems.org/gems/plex-autodelete'
  s.license     = 'MIT'
  s.add_runtime_dependency 'plex-ruby', '~> 1.5', '>= 1.5.1'
  s.add_runtime_dependency 'thor', '~> 0.19.1'
  s.add_runtime_dependency 'nori', '~> 2.4', '>= 2.4.0'
  s.add_runtime_dependency 'mini_portile', '~> 0.6.1'
  s.executables << 'plex-autodelete'
end
