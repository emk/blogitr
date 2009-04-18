require 'rubygems'
require 'yaml'
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
      if string =~ /\A.*:/
        if string =~ /\A((.|\n)*?)\n\n((.|\n)*)\z/
          # Headers and body.
          @headers = YAML::load($1)
          content = $3
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
      if content =~ /\A((.|\n)*?)<!--more-->\s*\n((.|\n)*)\z/
        @body = $1
        @extended = $3
      else
        @body = content
        @extended = nil
      end

      # Apply any markup filters to our content.
      if filter
        filter_proc = FILTERS[filter] or
          raise UnknownFilterError, "Unknown filter: #{filter}"
        @body = filter_proc.call(@body)
        @extended = filter_proc.call(@extended) if @extended
      end
    end
  end
end
