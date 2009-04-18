require 'yaml'

module Blogitr
  class Document
    attr_reader :body
    attr_reader :headers
    attr_reader :extended

    def initialize string
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
    end
  end
end
