$:.push File.expand_path("../lib", __FILE__)
require "rdf/edtf/version"

Gem::Specification.new do |spec|
  spec.name = "rdf-edtf"
  spec.version = RDF::EDTF::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Project Surfliner"]
  spec.homepage = "https://github.com/marrus-sh/rdf-edtf" # temporary
  spec.summary = "An `RDF::Literal` implementation around Extended Date Time Format."
  spec.description = "Supports serializing and parsing EDTF (all levels) as typed literals in RDF."
  spec.license = "MIT"

  spec.files = `git ls-files`.split("\n")
  spec.extra_rdoc_files = ["LICENSE", "README.md", "CHANGELOG.md"]

  spec.required_ruby_version = ">= 2.7"

  spec.add_dependency "rdf", "~> 3.3.0"
  spec.add_dependency "edtf", "~> 3.1.1"

  spec.add_development_dependency "debug"
  spec.add_development_dependency "rdf-spec", "~> 3.3.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "standard"
end
