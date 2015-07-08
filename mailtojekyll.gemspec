# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailtojekyll/version'

Gem::Specification.new do |spec|
  spec.name          = "mailtojekyll"
  spec.version       = Mailtojekyll::VERSION
  spec.authors       = ["Kate Klemp"]
  spec.email         = ["kklemp@misdepartment.com"]

  spec.summary       = %q{Allows users to send emails to post to a jekyll blog}
  spec.description   = %q{Uses POP3 to connect to a dedicated email address, fetch emails, and parse them into markdown posts for Jekyll to process}
  spec.homepage      = "https://github.com/misdepartment/mailtojekyll"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  
  spec.add_runtime_dependency 'mail', '~> 2.6'
  spec.add_runtime_dependency 'nokogiri', '~> 1.6'
  spec.add_runtime_dependency 'reverse_markdown', '~> 0.8'
  spec.add_runtime_dependency 'rinku', '~> 1.7'
end
