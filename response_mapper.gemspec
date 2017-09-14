# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "response_mapper/version"

Gem::Specification.new do |spec|
  spec.name          = "response_mapper"
  spec.version       = ResponseMapper::VERSION
  spec.authors       = ["Sergii Makagon"]
  spec.email         = ["makagon87@gmail.com"]

  spec.summary       = %q{Allows to map API response to domain language of your application}
  spec.description   = %q{Usually API returns data with naming that might not be the best fit for your application. You can map customer_id to user_id with ResponseMapper easily.}
  spec.homepage      = "https://github.com/smakagon/response_mapper"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'rubocop', '~> 0.49'
  spec.add_development_dependency 'pry', '~> 0.10'
end
