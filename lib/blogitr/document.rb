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

    # Construct a new Document.
    #
    # <code>:text</code>::
    #   A document to parse for <code>:headers</code>,
    #   <code>:raw_body</code> and <code>:raw_extended</code>.
    # <code>:headers</code>::
    #   A hash-table, keyed with strings, containing the document's YAML
    #   header.
    # <code>:raw_body</code>::
    #   The unparsed body of the document.
    # <code>:raw_extended</code>::
    #   The unparsed extended content of the document, or +nil+.
    # <code>:filter</code>::
    #   A symbol specifying what content filter to use for this document.
    def initialize opts
      if opts[:text]
        parse(opts[:text])
      else
        @headers = opts[:headers]
        @raw_body = opts[:raw_body]
        @raw_extended = opts[:raw_extended]
      end
      @filter = Blogitr.find_filter(opts[:filter])
    end

    # The body of the document, in HTML format.
    def body
      @body ||= process_text(@raw_body)
    end

    # The extended content of the document, in HTML format, or +nil+.
    def extended
      @extended ||= process_text(@raw_extended) if @raw_extended
    end

    # Convert a document to a string.  This is the inverse of
    # Document#parse.
    def to_s
      headers = ""
      headers = YAML::dump(@headers).sub(/^--- \n/, '') unless @headers.empty?
      extended = ""
      extended = "\n<!--more-->\n#{@raw_extended}" if @raw_extended
      "#{headers}\n#{@raw_body}#{extended}"
    end

    private

    # Parse +text+ into headers, body and extended content.
    def parse text
      # Extract our headers, if any.
      if text =~ /\A.*:/
        if text =~ /\A((?:.|\n)*?)\n\n((?:.|\n)*)\z/
          # Headers and body.
          @headers = YAML::load($1)
          content = $2
        else
          # Headers without body.
          @headers = YAML::load(text)
          content = ''
        end
      else
        # Body without headers.
        @headers = {}
        content = text
      end

      # Split the body at a <!--more--> marker, if we have one.
      if content =~ /\A((?:.|\n)*?)\n<!--more-->\s*\n((?:.|\n)*)\z/
        @raw_body = $1
        @raw_extended = $2
      else
        @raw_body = content
        @raw_extended = nil
      end      
    end

    # Apply macros and filters to +text+.
    def process_text text
      @filter.process(Blogitr.expand_macros(@filter, text))
    end
  end
end
