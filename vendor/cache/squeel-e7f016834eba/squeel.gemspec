# -*- encoding: utf-8 -*-
# stub: squeel 1.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "squeel"
  s.version = "1.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Ernie Miller", "Xiang Li"]
  s.date = "2015-03-16"
  s.description = "\n      Squeel unlocks the power of Arel in your Rails application with\n      a handy block-based syntax. You can write subqueries, access named\n      functions provided by your RDBMS, and more, all without writing\n      SQL strings. Supporting Rails 3 and 4.\n    "
  s.email = ["ernie@erniemiller.org", "bigxiang@gmail.com"]
  s.files = [".gitignore", ".rspec", ".travis.yml", ".yardopts", "CHANGELOG.md", "Gemfile", "LICENSE", "README.md", "Rakefile", "lib/generators/squeel/initializer_generator.rb", "lib/generators/templates/squeel.rb", "lib/squeel.rb", "lib/squeel/adapters/active_record.rb", "lib/squeel/adapters/active_record/3.0/association_preload_extensions.rb", "lib/squeel/adapters/active_record/3.0/compat.rb", "lib/squeel/adapters/active_record/3.0/context.rb", "lib/squeel/adapters/active_record/3.0/join_dependency_extensions.rb", "lib/squeel/adapters/active_record/3.0/relation_extensions.rb", "lib/squeel/adapters/active_record/3.1/compat.rb", "lib/squeel/adapters/active_record/3.1/context.rb", "lib/squeel/adapters/active_record/3.1/join_dependency_extensions.rb", "lib/squeel/adapters/active_record/3.1/preloader_extensions.rb", "lib/squeel/adapters/active_record/3.1/relation_extensions.rb", "lib/squeel/adapters/active_record/3.2/compat.rb", "lib/squeel/adapters/active_record/3.2/context.rb", "lib/squeel/adapters/active_record/3.2/join_dependency_extensions.rb", "lib/squeel/adapters/active_record/3.2/preloader_extensions.rb", "lib/squeel/adapters/active_record/3.2/relation_extensions.rb", "lib/squeel/adapters/active_record/4.0/compat.rb", "lib/squeel/adapters/active_record/4.0/context.rb", "lib/squeel/adapters/active_record/4.0/join_dependency_extensions.rb", "lib/squeel/adapters/active_record/4.0/preloader_extensions.rb", "lib/squeel/adapters/active_record/4.0/relation_extensions.rb", "lib/squeel/adapters/active_record/4.1/compat.rb", "lib/squeel/adapters/active_record/4.1/context.rb", "lib/squeel/adapters/active_record/4.1/preloader_extensions.rb", "lib/squeel/adapters/active_record/4.1/reflection_extensions.rb", "lib/squeel/adapters/active_record/4.1/relation_extensions.rb", "lib/squeel/adapters/active_record/4.2/compat.rb", "lib/squeel/adapters/active_record/4.2/context.rb", "lib/squeel/adapters/active_record/4.2/preloader_extensions.rb", "lib/squeel/adapters/active_record/4.2/relation_extensions.rb", "lib/squeel/adapters/active_record/base_extensions.rb", "lib/squeel/adapters/active_record/compat.rb", "lib/squeel/adapters/active_record/context.rb", "lib/squeel/adapters/active_record/join_dependency_extensions.rb", "lib/squeel/adapters/active_record/preloader_extensions.rb", "lib/squeel/adapters/active_record/relation_extensions.rb", "lib/squeel/configuration.rb", "lib/squeel/constants.rb", "lib/squeel/context.rb", "lib/squeel/core_ext/hash.rb", "lib/squeel/core_ext/symbol.rb", "lib/squeel/dsl.rb", "lib/squeel/nodes.rb", "lib/squeel/nodes/aliasing.rb", "lib/squeel/nodes/and.rb", "lib/squeel/nodes/as.rb", "lib/squeel/nodes/binary.rb", "lib/squeel/nodes/function.rb", "lib/squeel/nodes/grouping.rb", "lib/squeel/nodes/join.rb", "lib/squeel/nodes/key_path.rb", "lib/squeel/nodes/literal.rb", "lib/squeel/nodes/nary.rb", "lib/squeel/nodes/node.rb", "lib/squeel/nodes/not.rb", "lib/squeel/nodes/operation.rb", "lib/squeel/nodes/operators.rb", "lib/squeel/nodes/or.rb", "lib/squeel/nodes/order.rb", "lib/squeel/nodes/ordering.rb", "lib/squeel/nodes/predicate.rb", "lib/squeel/nodes/predicate_methods.rb", "lib/squeel/nodes/predicate_operators.rb", "lib/squeel/nodes/sifter.rb", "lib/squeel/nodes/stub.rb", "lib/squeel/nodes/subquery_join.rb", "lib/squeel/nodes/unary.rb", "lib/squeel/version.rb", "lib/squeel/visitors.rb", "lib/squeel/visitors/enumeration_visitor.rb", "lib/squeel/visitors/from_visitor.rb", "lib/squeel/visitors/group_visitor.rb", "lib/squeel/visitors/having_visitor.rb", "lib/squeel/visitors/order_visitor.rb", "lib/squeel/visitors/predicate_visitation.rb", "lib/squeel/visitors/predicate_visitor.rb", "lib/squeel/visitors/preload_visitor.rb", "lib/squeel/visitors/select_visitor.rb", "lib/squeel/visitors/visitor.rb", "lib/squeel/visitors/where_visitor.rb", "spec/config.travis.yml", "spec/config.yml", "spec/console.rb", "spec/core_ext/symbol_spec.rb", "spec/helpers/squeel_helper.rb", "spec/spec_helper.rb", "spec/squeel/adapters/active_record/base_extensions_spec.rb", "spec/squeel/adapters/active_record/context_spec.rb", "spec/squeel/adapters/active_record/join_dependency_extensions_spec.rb", "spec/squeel/adapters/active_record/relation_extensions_spec.rb", "spec/squeel/core_ext/symbol_spec.rb", "spec/squeel/dsl_spec.rb", "spec/squeel/nodes/as_spec.rb", "spec/squeel/nodes/function_spec.rb", "spec/squeel/nodes/grouping_spec.rb", "spec/squeel/nodes/join_spec.rb", "spec/squeel/nodes/key_path_spec.rb", "spec/squeel/nodes/literal_spec.rb", "spec/squeel/nodes/operation_spec.rb", "spec/squeel/nodes/operators_spec.rb", "spec/squeel/nodes/order_spec.rb", "spec/squeel/nodes/predicate_operators_spec.rb", "spec/squeel/nodes/predicate_spec.rb", "spec/squeel/nodes/sifter_spec.rb", "spec/squeel/nodes/stub_spec.rb", "spec/squeel/nodes/subquery_join_spec.rb", "spec/squeel/visitors/from_visitor_spec.rb", "spec/squeel/visitors/order_visitor_spec.rb", "spec/squeel/visitors/predicate_visitor_spec.rb", "spec/squeel/visitors/preload_visitor_spec.rb", "spec/squeel/visitors/select_visitor_spec.rb", "spec/squeel/visitors/visitor_spec.rb", "spec/support/models.rb", "spec/support/schema.rb", "squeel.gemspec"]
  s.homepage = "https://github.com/ernie/squeel"
  s.rubyforge_project = "squeel"
  s.rubygems_version = "2.4.5"
  s.summary = "Active Record, improved."
  s.test_files = ["spec/config.travis.yml", "spec/config.yml", "spec/console.rb", "spec/core_ext/symbol_spec.rb", "spec/helpers/squeel_helper.rb", "spec/spec_helper.rb", "spec/squeel/adapters/active_record/base_extensions_spec.rb", "spec/squeel/adapters/active_record/context_spec.rb", "spec/squeel/adapters/active_record/join_dependency_extensions_spec.rb", "spec/squeel/adapters/active_record/relation_extensions_spec.rb", "spec/squeel/core_ext/symbol_spec.rb", "spec/squeel/dsl_spec.rb", "spec/squeel/nodes/as_spec.rb", "spec/squeel/nodes/function_spec.rb", "spec/squeel/nodes/grouping_spec.rb", "spec/squeel/nodes/join_spec.rb", "spec/squeel/nodes/key_path_spec.rb", "spec/squeel/nodes/literal_spec.rb", "spec/squeel/nodes/operation_spec.rb", "spec/squeel/nodes/operators_spec.rb", "spec/squeel/nodes/order_spec.rb", "spec/squeel/nodes/predicate_operators_spec.rb", "spec/squeel/nodes/predicate_spec.rb", "spec/squeel/nodes/sifter_spec.rb", "spec/squeel/nodes/stub_spec.rb", "spec/squeel/nodes/subquery_join_spec.rb", "spec/squeel/visitors/from_visitor_spec.rb", "spec/squeel/visitors/order_visitor_spec.rb", "spec/squeel/visitors/predicate_visitor_spec.rb", "spec/squeel/visitors/preload_visitor_spec.rb", "spec/squeel/visitors/select_visitor_spec.rb", "spec/squeel/visitors/visitor_spec.rb", "spec/support/models.rb", "spec/support/schema.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0"])
      s.add_runtime_dependency(%q<polyamorous>, ["~> 1.1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<faker>, ["~> 0.9.5"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_development_dependency(%q<mysql>, ["~> 2.9.1"])
      s.add_development_dependency(%q<mysql2>, ["~> 0.3.16"])
      s.add_development_dependency(%q<pg>, ["~> 0.17.1"])
      s.add_development_dependency(%q<git_pretty_accept>, ["~> 0.4.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.0"])
      s.add_dependency(%q<activesupport>, [">= 3.0"])
      s.add_dependency(%q<polyamorous>, ["~> 1.1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<faker>, ["~> 0.9.5"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_dependency(%q<mysql>, ["~> 2.9.1"])
      s.add_dependency(%q<mysql2>, ["~> 0.3.16"])
      s.add_dependency(%q<pg>, ["~> 0.17.1"])
      s.add_dependency(%q<git_pretty_accept>, ["~> 0.4.0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.0"])
    s.add_dependency(%q<activesupport>, [">= 3.0"])
    s.add_dependency(%q<polyamorous>, ["~> 1.1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<faker>, ["~> 0.9.5"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
    s.add_dependency(%q<mysql>, ["~> 2.9.1"])
    s.add_dependency(%q<mysql2>, ["~> 0.3.16"])
    s.add_dependency(%q<pg>, ["~> 0.17.1"])
    s.add_dependency(%q<git_pretty_accept>, ["~> 0.4.0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
