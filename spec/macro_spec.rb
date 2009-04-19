require 'spec_helper'

describe Blogitr::Macro do
  def expand text, filter = :html
    Blogitr.expand_macros(Blogitr.find_filter(filter), text)
  end

  it "should require #expand to be overridden" do
    macro = Blogitr::Macro.new
    lambda do
      macro.expand(Blogitr.find_filter(:textile), "")
    end.should raise_error(RuntimeError)
  end

  it "should convert unknown macros to raw HTML" do
    text = "<macro:unknown a='b'>c</macro:unknown>"
    expand(text).should == CGI.escapeHTML(text)
  end

  it "should expand known macros" do
    expand("<macro:example>foo</macro:example>").should ==
      %Q(Options: {}\nBody: foo)
  end

  it "should protect expanded macros from filters" do
    expand("<macro:example>foo</macro:example>", :textile).should ==
      %Q(<notextile>Options: {}\nBody: foo</notextile>)
  end

  describe "attribute parser" do
    it "should parse macros without arguments" do
      expand("<macro:example></macro:example>").should ==
        %Q(Options: {}\nBody: )
    end

    it "should parse doubly-quoted arguments" do
      expand("<macro:example a=\"b\"></macro:example>").should ==
        %Q(Options: {"a"=>"b"}\nBody: )
    end

    it "should parse singly-quoted arguments" do
      expand("<macro:example a='b'></macro:example>").should ==
        %Q(Options: {"a"=>"b"}\nBody: )
    end

    it "should not be fooled by '>' characters in attributes" do
      expand("<macro:example a='>'></macro:example>").should ==
        %Q(Options: {"a"=>">"}\nBody: )
      expand("<macro:example a=\">\"></macro:example>").should ==
        %Q(Options: {"a"=>">"}\nBody: )
    end

    it "should expand XML entities" do
      expand("<macro:example a='&lt;'></macro:example>").should ==
        %Q(Options: {"a"=>"<"}\nBody: )
    end
  end
end
