require 'rubygems'
require 'yaml'
require 'redcloth'
require 'rdiscount'

module Blogitr
  FILTERS={
    :textile => proc {|text| RedCloth.new(text) },
    :markdown => proc {|text| RDiscount.new(text, :smart) }
  }

  class Document
    attr_reader :body
    attr_reader :headers
    attr_reader :extended

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
        filter_proc = FILTERS[filter]
        @body = filter_proc.call(@body).to_html
        @extended = filter_proc.call(@extended).to_html if @extended
      end
    end
  end
end
