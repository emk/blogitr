require 'spec_helper'
require 'blogitr/document'

describe Blogitr::Document do
  def should_parse_as headers, body, extended
    @doc.headers.should == headers
    @doc.body.should == body
    @doc.extended.should == extended
  end

  it "should parse documents with no YAML header" do
    @doc = Blogitr::Document.new "foo\nbar\nbaz"
    should_parse_as({}, "foo\nbar\nbaz", nil)
  end

  it "should parse documents with a YAML header" do
    @doc = Blogitr::Document.new <<EOD
title: My Doc
subtitle: An Essay

foo

bar
EOD
    should_parse_as({ 'title' => "My Doc", 'subtitle' => 'An Essay' },
                    "foo\n\nbar\n", nil)
  end

  it "should parse documents with no body" do
    @doc = Blogitr::Document.new("title: My Doc")
    should_parse_as({ 'title' => "My Doc" }, '', nil)
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
    @doc = Blogitr::Document.new("foo _bar_ \"baz\"", :textile)
    should_parse_as({}, "<p>foo <em>bar</em> &#8220;baz&#8221;</p>", nil)
  end
end
