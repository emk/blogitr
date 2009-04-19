require 'spec_helper'

describe Blogitr::Document do
  def parse text, filter=:html
    @doc = Blogitr::Document.new :text => text, :filter => filter
  end

  def should_parse_as headers, body, extended=nil
    @doc.headers.should == headers
    @doc.body.should == body
    @doc.extended.should == extended
  end

  it "should raise an error if an unknown fitler is specified" do
    lambda do
      parse "foo *bar* \"baz\"", :unknown
    end.should raise_error(Blogitr::UnknownFilterError)
  end

  it "should parse documents with a YAML header" do
    parse <<EOD
title: My Doc
subtitle: An Essay

foo

bar
EOD
    should_parse_as({ 'title' => "My Doc", 'subtitle' => 'An Essay' },
                    "foo\n\nbar\n")
  end

  it "should parse documents without a YAML header" do
    parse "foo\nbar\nbaz"
    should_parse_as({}, "foo\nbar\nbaz")
  end

  it "should parse documents with a YAML header but no body" do
    parse "title: My Doc"
    should_parse_as({ 'title' => "My Doc" }, '')
  end

  it "should separate extended content from the main body" do
    parse <<EOD
foo
<!--more--> 
bar
EOD
    should_parse_as({}, "foo", "bar\n")
  end

  it "should expand macros" do
    input = "title: Foo\n\n<macro:example foo=\"bar\">baz</macro:example>"
    parse input
    should_parse_as({'title' => "Foo"},
                    "Options: {\"foo\"=>\"bar\"}\nBody: baz")
  end

  it "should provide access to raw body and extended content" do
    parse "*foo*\n<!--more-->\n_bar_", :textile
    @doc.raw_body.should == "*foo*"
    @doc.raw_extended.should == "_bar_"
  end

  describe "with a :textile filter" do
    it "should filter content" do
      parse "foo *bar*\n<!--more-->\n\"baz\"", :textile
      should_parse_as({}, "<p>foo <strong>bar</strong></p>",
                      "<p>&#8220;baz&#8221;</p>")
    end

    it "should protect expanded macros from filtering" do
      text = "\n<macro:example>*foo*</macro:example>"
      parse text, :textile
      should_parse_as({},  "Options: {}\nBody: *foo*")
    end
  end

  describe "with a :markdown filter" do
    it "should filter content" do
      parse "foo *bar* \"baz\"", :markdown
      should_parse_as({}, "<p>foo <em>bar</em> &ldquo;baz&rdquo;</p>\n")
    end

    it "should protect expanded macros from filtering" do
      text = "\n<macro:example>*foo*</macro:example>"
      parse text, :markdown
      should_parse_as({},
                      "<div class=\"raw\">Options: {}\nBody: *foo*</div>\n\n")
    end
  end

  describe "#to_s" do
    def should_serialize_as headers, body, extended, serialized
      opts = { :headers => headers, :raw_body => body,
               :raw_extended => extended, :filter => :html }
      Blogitr::Document.new(opts).to_s.should == serialized
    end

    it "should serialize documents with headers" do
      should_serialize_as({'title' => 'Foo'}, "_Bar_.", nil,
                          "title: Foo\n\n_Bar_.")
    end

    it "should serialize documents without headers" do
      should_serialize_as({}, "_Bar_.", nil, "\n_Bar_.")      
    end

    it "should serialize extended content using \\<!--more-->" do
      should_serialize_as({}, "Bar.", "_Baz_.", "\nBar.\n<!--more-->\n_Baz_.")
    end
  end
end
