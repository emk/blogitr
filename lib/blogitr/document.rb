require 'yaml'

module Blogitr
  # A document consists of headers, a body, and (optionally) extended
  # content.  For example:
  #
  #   title: My document
  #
  #   This is the body.
  #   <!--more-->
  #   This is the extended content.
  #
  # A document may consist of raw HTML, or it may be processed using a
  # filter such as textile or Markdown.
  class Document
    # The document headers.  This is the result of calling YAML::load on
    # the header block at the top of the document.
    attr_reader :headers

    # The unprocessed body of the document.
    attr_reader :raw_body

    # The unprocessed portion of the document appearing after the first
    # line containing \<!--more-->, if any.  May be +nil+.
    attr_reader :raw_extended

    # Parse +string+ into headers, body and extended content, and return a
    # Document.
    def self.parse string, filter
      # Extract our headers, if any.
      if string =~ /\A.*:/
        if string =~ /\A((?:.|\n)*?)\n\n((?:.|\n)*)\z/
          # Headers and body.
          headers = YAML::load($1)
          content = $2
        else
          # Headers without body.
          headers = YAML::load(string)
          content = ''
        end
      else
        # Body without headers.
        headers = {}
        content = string
      end

      # Split the body at a <!--more--> marker, if we have one.
      if content =~ /\A((?:.|\n)*?)<!--more-->\s*\n((?:.|\n)*)\z/
        body = $1
        extended = $2
      else
        body = content
        extended = nil
      end      

      # Create our Document.
      new headers, body, extended, filter
    end

    # Construct a new Document, using +headers+, +raw_body+ and
    # +raw_extended+, and use +filter+ to process +raw_body+ and
    # +raw_extended+.  +headers+ should be a hash table, and +filter+
    # should be a symbol corresponding to a registered Filter.
    def initialize headers, raw_body, raw_extended, filter
      @headers = headers
      @raw_body = raw_body
      @raw_extended = raw_extended

      # Look up our text filter.
      @filter = Blogitr.find_filter(filter)
    end

    def body
      @body ||= process_text(@raw_body)
    end

    def extended
      @extended ||= process_text(@raw_extended) if @raw_extended
    end

    protected

    def process_text text
      @filter.process(Blogitr.expand_macros(@filter, text))
    end
  end
end
