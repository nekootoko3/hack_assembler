require_relative 'lib/hack_assembler/version'

Gem::Specification.new do |spec|
  spec.name          = "hack_assembler"
  spec.version       = HackAssembler::VERSION
  spec.authors       = ["nekootoko3"]
  spec.email         = ["nekootoko3@gmail.com"]

  spec.summary       = "assemble programming language hack"
  spec.description   = "assemble programming language hack"
  spec.homepage      = "https://github.com/nekootoko3/hack_assembler"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/nekootoko3/hack_assembler/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
