require 'spec_helper'

describe Blogitr::Blog do
  before do
    @blog = example_blog
  end

  it "should have a title" do
    @blog.title.should == "My blog"
  end

  it "should return articles in reverse-chronological order" do
    articles = @blog.articles
    articles[0].title.should == "My newest post"
    articles[1].title.should == "My second-newest post"
  end

  it "should allow searching for an individual article" do
    article = @blog.article(2009, 4, 19, 'my-second-newest-post')
    article.title.should == "My second-newest post"
  end

  it "should raise an error if an article can't be found" do
    lambda do
      article = @blog.article(2009, 4, 19, 'does-not-exist')
    end.should raise_error(Blogitr::ArticleNotFoundError)
  end
end
