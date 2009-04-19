require 'rexml/document'
require 'cgi'

module Blogitr
  MACROS = {}

  # Register +macro+ under the symbol +name+.
  def self.register_macro name, macro
    MACROS[name] = macro
  end

  # Expand all macros in +text+.
  def self.expand_macros text
    pattern = /<macro:([-_A-Za-z0-9]+) ((?:[^>'"]|"[^"]*"|'[^']*')*) >
               ((?:.|\n)*?)
               <\/macro:\1>/x
    text.gsub(pattern) do |match|
      macro = MACROS[$1.to_sym]
      if macro
        attributes = {}
        xml_doc = REXML::Document.new("<tag #{$2} />")
        xml_doc.root.attributes.each {|a, b| attributes[a] = b }
        body = $3
        macro.expand(attributes, body)
      else
        CGI.escapeHTML(match)
      end
    end
  end

  # A macro expands a piece of specialized inline markup in a document.
  # For example:
  #
  #   <macro:code lang="ruby">
  #   REGISTRATIONS = {}
  #   </macro:code>
  #
  # A macro looks like an XML tag, but it actually contains plain text.
  # Macros may not be nested.
  class Macro
    # Given +options+ (parsed from the macro's XML-style "attributes") and
    # +body+ (the raw text found inside the macro), return a fragment of
    # valid XHTML.
    def expand options, body
      raise "You must override Macro#filter"
    end
  end
end
