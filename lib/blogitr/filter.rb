require 'rubygems'
require 'redcloth'
require 'rdiscount'

module Blogitr
  FILTERS = {}

  # This is error is raised for filter names which haven't been registered
  # using register_filter.
  class UnknownFilterError < RuntimeError
  end

  # A filter which converts a markup language to HTML.
  class Filter
    # Convert +text+ to HTML.
    def process text
      raise "Must override Filter#process"
    end

    # Protect +html+ against further processing by this filter.
    def protect_html html
      raise "Must override Filter#protect_html"
    end
  end

  # Register +filter+ under the symbol +name+.
  def self.register_filter name, filter
    FILTERS[name] = filter
  end

  # Look up a filter by +name+.  Raises UnknownFilterError if no filter has
  # been registered under that name.
  def self.find_filter name
    FILTERS[name] or
      raise UnknownFilterError, "Unknown filter: #{name}"
  end

  # Pass raw HTML through unchanged.
  class RawHtmlFilter < Filter
    def process text
      text
    end
    def protect_html html
      html
    end
  end
  register_filter(:html, RawHtmlFilter.new)

  # Convert textile markup to HTML.
  class TextileFilter < Filter
    def process text
      RedCloth.new(text).to_html
    end
    def protect_html html
      "<notextile>#{html}</notextile>"
    end
  end
  register_filter(:textile, TextileFilter.new)

  # Convert Markdown markup to HTML.
  class MarkdownFilter < Filter
    def process text
      RDiscount.new(text, :smart).to_html
    end
    def protect_html html
      # Wrapping raw HTML in another tag prevents Markdown from messing
      # with it.  We can probably do better, but this is good for now.
      "<div class=\"raw\">#{html}</div>"
    end
  end
  register_filter(:markdown, MarkdownFilter.new)
end
