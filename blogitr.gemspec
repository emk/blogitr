# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{blogitr}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Kidd"]
  s.date = %q{2009-04-19}
  s.email = %q{git@randomhacks.net}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["README.rdoc", "VERSION.yml", "lib/blogitr", "lib/blogitr/article.rb", "lib/blogitr/blog.rb", "lib/blogitr/document.rb", "lib/blogitr/filter.rb", "lib/blogitr/macro.rb", "lib/blogitr.rb", "spec/article_spec.rb", "spec/blog", "spec/blog/2009", "spec/blog/2009/04", "spec/blog/2009/04/19", "spec/blog/2009/04/19/0946-my-second-newest-post.markdown", "spec/blog/2009/04/19/0947-my-newest-post.textile", "spec/blog/blog.yml", "spec/blog_spec.rb", "spec/document_spec.rb", "spec/filter_spec.rb", "spec/macro_spec.rb", "spec/spec_helper.rb", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/emk/blogitr}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<RedCloth>, [">= 4.1.9"])
      s.add_runtime_dependency(%q<rdiscount>, [">= 1.3.4"])
      s.add_development_dependency(%q<rspec>, [">= 1.1.11.3"])
    else
      s.add_dependency(%q<RedCloth>, [">= 4.1.9"])
      s.add_dependency(%q<rdiscount>, [">= 1.3.4"])
      s.add_dependency(%q<rspec>, [">= 1.1.11.3"])
    end
  else
    s.add_dependency(%q<RedCloth>, [">= 4.1.9"])
    s.add_dependency(%q<rdiscount>, [">= 1.3.4"])
    s.add_dependency(%q<rspec>, [">= 1.1.11.3"])
  end
end
