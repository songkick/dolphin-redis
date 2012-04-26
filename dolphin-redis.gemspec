spec = Gem::Specification.new do |s|
  s.name              = "dolphin-redis"
  s.version           = "0.1.1"
  s.summary           = "Redis support for the friendly feature flipper"
  s.author            = "Vivien Barousse"
  s.email             = "barousse.vivien@gmail.com"
  s.homepage          = "http://vivien.barous.se"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.rdoc)
  s.rdoc_options      = %w(--main README.rdoc)

  s.files             = %w(README.rdoc MIT-LICENSE) + Dir.glob("{spec,lib/**/*}")
  s.require_paths     = ["lib"]

  s.add_dependency("redis")
  s.add_development_dependency("rspec")
end
