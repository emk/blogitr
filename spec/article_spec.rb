require 'spec_helper'

describe Blogitr::Article do
  before do
    @blog = example_blog
    @article = @blog.articles[0]
  end

  it "should have a title" do
    @article.title.should == 'My newest post'
  end

  it "should have a permalink" do
    @article.permalink.should == 'my-newest-post'
  end
end
