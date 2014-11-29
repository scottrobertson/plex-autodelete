Gem::Specification.new do |s|
  s.name        = 'plex-autodelete'
  s.version     = '0.0.1'
  s.date        = '2014-11-29'
  s.description = "Automatically removed watched episodes in Plex"
  s.authors     = ["Scott Robertson"]
  s.email       = 'scottymeuk@gmail.com'
  s.files       = ["lib/plex-autodelete.rb"]
  s.homepage    = 'http://rubygems.org/gems/plex-autodelete'
  s.license     = 'MIT'
  s.add_runtime_dependency 'plex-ruby'
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'nori'
  s.executables << 'plex-autodelete'
end
