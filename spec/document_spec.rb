require 'spec_helper'

describe Blogitr::Document do
  def should_parse_as headers, body, extended=nil
    @doc.headers.should == headers
    @doc.body.should == body
    @doc.extended.should == extended
  end

  it "should parse documents with no YAML header" do
    @doc = Blogitr::Document.new "foo\nbar\nbaz"
    should_parse_as({}, "foo\nbar\nbaz")
  end

  it "should parse documents with a YAML header" do
    @doc = Blogitr::Document.new <<EOD
title: My Doc
subtitle: An Essay

foo

bar
EOD
    should_parse_as({ 'title' => "My Doc", 'subtitle' => 'An Essay' },
                    "foo\n\nbar\n")
  end

  it "should parse documents with no body" do
    @doc = Blogitr::Document.new("title: My Doc")
    should_parse_as({ 'title' => "My Doc" }, '')
  end

  it "should separate extended content from the main body" do
    @doc = Blogitr::Document.new <<EOD
foo
<!--more--> 
bar
EOD
    should_parse_as({}, "foo\n", "bar\n")
  end

  it "should parse textile content" do
    @doc = Blogitr::Document.new("foo *bar*\n<!--more-->\n\"baz\"", :textile)
    should_parse_as({}, "<p>foo <strong>bar</strong></p>",
                    "<p>&#8220;baz&#8221;</p>")
  end

  it "should parse Markdown content" do
    @doc = Blogitr::Document.new("foo *bar* \"baz\"", :markdown)
    should_parse_as({}, "<p>foo <em>bar</em> &ldquo;baz&rdquo;</p>\n")
  end

  it "should raise an error if an unknown fitler is specified" do
    lambda do
      @doc = Blogitr::Document.new("foo *bar* \"baz\"", :unknown)
    end.should raise_error(Blogitr::UnknownFilterError)
  end

  it "should expand macros" do
    input = "title: Foo\n\n<macro:example foo=\"bar\">baz</macro:example>"
    @doc = Blogitr::Document.new(input)
    should_parse_as({'title' => "Foo"},
                    "Options: {\"foo\"=>\"bar\"}\nBody: baz")
  end

  it "should protect expanded macros from textile" do
    text = "\n<macro:example>*foo*</macro:example>"
    @doc = Blogitr::Document.new(text, :textile)
    should_parse_as({},  "Options: {}\nBody: *foo*")
  end

  it "should protect expanded macros from Markdown" do
    text = "\n<macro:example>*foo*</macro:example>"
    @doc = Blogitr::Document.new(text, :markdown)
    should_parse_as({}, "<div class=\"raw\">Options: {}\nBody: *foo*</div>\n\n")
  end
end
