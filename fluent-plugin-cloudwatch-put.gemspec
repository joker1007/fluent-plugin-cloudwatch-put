lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = "fluent-plugin-cloudwatch-put"
  spec.version = "0.2.2"
  spec.authors = ["joker1007"]
  spec.email   = ["kakyoin.hierophant@gmail.com"]

  spec.summary       = %q{Cloudwatch put metric plugin for fluentd.}
  spec.description   = %q{Cloudwatch put metric plugin for fluentd.}
  spec.homepage      = "https://github.com/joker1007/fluent-plugin-cloudwatch-put"
  spec.license       = "MIT"

  test_files, files  = `git ls-files -z`.split("\x0").partition do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "test-unit", "~> 3.0"
  spec.add_development_dependency "test-unit-rr"

  spec.add_runtime_dependency "fluentd", [">= 0.14.10", "< 2"]
  spec.add_runtime_dependency "aws-sdk-cloudwatch", "~> 1"
end
