lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'astree/version'

Gem::Specification.new do |spec|
  spec.name          = 'astree'
  spec.version       = ASTree::VERSION
  spec.authors       = ['Shuichi Tamayose']
  spec.email         = ['tmshuichi@gmail.com']

  spec.summary       = %q{ASTree is like tree command for RubyVM::AbstractSyntaxTree}
  spec.description   = %q{ASTree is like tree command for RubyVM::AbstractSyntaxTree}
  spec.homepage      = 'https://github.com/siman-man/astree'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6.1'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'colorize', '~> 0.8'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
