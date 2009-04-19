require 'rubygems'
require 'yaml'
require 'rexml/document'
require 'redcloth'
require 'rdiscount'

module Blogitr
  # A hash that maps filter names (represented as symbols) to filter
  # functions.  To add a new entry, write:
  #
  #   Blogitr::FILTERS[:textile] = proc {|text| RedCloth.new(text).to_html }
  FILTERS={
    :textile => proc {|text| RedCloth.new(text).to_html },
    :markdown => proc {|text| RDiscount.new(text, :smart).to_html }
  }

  # This is error is raised for filter names which do not appear in
  # Blogitr::FILTERS.
  class UnknownFilterError < RuntimeError
  end

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

    # The body of the document.
    attr_reader :body

    # The portion of the document appearing after the first line containing
    # \<!--more-->, if any.
    attr_reader :extended

    # Parse +string+ into headers, body and extended content, and apply an
    # optional +filter+ from Blogitr::FILTERS to the body and extended
    # content.
    def initialize string, filter=nil
      # Look up our text filter.
      if filter
        @filter = FILTERS[filter] or
          raise UnknownFilterError, "Unknown filter: #{filter}"
      end

      # Extract our headers, if any.
      if string =~ /\A.*:/
        if string =~ /\A((?:.|\n)*?)\n\n((?:.|\n)*)\z/
          # Headers and body.
          @headers = YAML::load($1)
          content = $2
        else
          # Headers without body.
          @headers = YAML::load(string)
          content = ''
        end
      else
        # Body without headers.
        @headers = {}
        content = string
      end

      # Split the body at a <!--more--> marker, if we have one.
      if content =~ /\A((?:.|\n)*?)<!--more-->\s*\n((?:.|\n)*)\z/
        @body = $1
        @extended = $2
      else
        @body = content
        @extended = nil
      end

      # Apply macros and filters to our content.
      @body = process_text(body)
      @extended = process_text(extended) if @extended
    end

    protected

    def process_text text
      text = @filter.call(text) if @filter
      apply_macros(text)
    end

    def apply_macros text
      text.gsub(/<macro:([-_A-Za-z0-9]+)([^>]*)>((?:.|\n)*?)<\/macro:\1>/) do
        macro_name = $1.to_sym
        attributes = parse_attributes($2)
        body = $3
        MACROS[macro_name].expand(attributes, body)
      end
    end

    # Parse a string containing XML-format attributes.
    def parse_attributes attributes
      result = {}
      xml_doc = REXML::Document.new("<tag #{attributes} />")
      xml_doc.root.attributes.each {|a, b| result[a] = b }
      result
    end
  end
end
