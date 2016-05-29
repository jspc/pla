# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "pla"
  spec.version       = '0.4.0'
  spec.authors       = ["jspc"]
  spec.email         = ["james@zero-internet.org.uk"]

  spec.summary       = 'Scrape and interact with the Port of London Authority Movements list'
  spec.homepage      = 'https://github.com/jspc/pla'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "iso_country_codes", "0.7.5"
  spec.add_dependency "nokogiri", "~> 1.6"
end
