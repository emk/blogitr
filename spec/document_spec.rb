require 'spec_helper'
require 'blogitr/document'

describe Blogitr::Document do
  it "should parse documents with no YAML header" do
    @doc = Blogitr::Document.new "foo\nbar\nbaz"
    @doc.headers.should == {}
    @doc.body.should == "foo\nbar\nbaz"
    @doc.extended.should == nil
  end

  it "should parse documents with a YAML header" do
    @doc = Blogitr::Document.new <<EOD
title: My Doc
subtitle: An Essay

foo

bar
EOD
    @doc.headers.should == { 'title' => "My Doc", 'subtitle' => 'An Essay' }
    @doc.body.should == "foo\n\nbar\n"
    @doc.extended.should == nil
  end

  it "should parse documents with no body" do
    @doc = Blogitr::Document.new("title: My Doc")
    @doc.headers.should == { 'title' => "My Doc" }
    @doc.body.should == ''
    @doc.extended.should == nil
  end

  it "should separate extended content from the main body" do
    @doc = Blogitr::Document.new <<EOD
foo
<!--more--> 
bar
EOD
    @doc.body.should == "foo\n"
    @doc.extended.should == "bar\n"
  end
end
