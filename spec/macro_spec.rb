require 'spec_helper'

describe Blogitr::Macro do
  def expand text
    Blogitr.expand_macros(text)
  end

  it "should expand macros with no arguments" do
    expand("<macro:example>foo</macro:example>").should ==
      %Q(Options: {}\nBody: foo)
  end

  it "should expand macros with doubly-quoted arguments" do
    expand("<macro:example a=\"b\"></macro:example>").should ==
      %Q(Options: {"a"=>"b"}\nBody: )
  end

  it "should expand macros with singly-quoted arguments" do
    expand("<macro:example a='b'></macro:example>").should ==
      %Q(Options: {"a"=>"b"}\nBody: )
  end

  it "should expand macros with attributes containing '>' characters" do
    expand("<macro:example a='>'></macro:example>").should ==
      %Q(Options: {"a"=>">"}\nBody: )
    expand("<macro:example a=\">\"></macro:example>").should ==
      %Q(Options: {"a"=>">"}\nBody: )
  end

  it "should expand macros with attributes containing entities" do
    expand("<macro:example a='&lt;'></macro:example>").should ==
      %Q(Options: {"a"=>"<"}\nBody: )
  end

  # raise error for unknown macro
  # wrap HTML output in <notextile>, etc.
end
