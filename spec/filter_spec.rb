require 'spec_helper'

describe Blogitr::Filter do
  it "should require #process and #protect_html to be overridden" do
    filter = Blogitr::Filter.new
    lambda do
      filter.process("")
    end.should raise_error(RuntimeError)
    lambda do
      filter.protect_html("")
    end.should raise_error(RuntimeError)
  end
end

describe Blogitr::MarkdownFilter do
  describe "#protect_html" do
    before do
      @filter = Blogitr.find_filter(:markdown)
    end

    it "should wrap bare text in a <div> tag" do
      @filter.protect_html("foo").should == %Q(<div class="raw">foo</div>)
    end

    it "should do nothing if HTML is already wrapped in a tag" do
      @filter.protect_html("<p>foo</p>").should == "<p>foo</p>"
    end
  end
end

