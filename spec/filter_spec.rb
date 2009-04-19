require 'spec_helper'

describe Blogitr::Filter do
  it "should require process and protect_html to be overridden" do
    filter = Blogitr::Filter.new
    lambda do
      filter.process("")
    end.should raise_error(RuntimeError)
    lambda do
      filter.protect_html("")
    end.should raise_error(RuntimeError)
  end
end

