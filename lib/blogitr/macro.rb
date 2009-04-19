require 'rexml/document'
require 'cgi'

module Blogitr
  MACROS = {} #:nodoc:

  # Register +macro+ under the symbol +name+.
  def self.register_macro name, macro
    MACROS[name] = macro
  end

  # Expand all macros in +text+ (and do our best to protect their
  # expansions against further munging by +filter+).
  def self.expand_macros filter, text
    pattern = /<macro:([-_A-Za-z0-9]+) ((?:[^>'"]|"[^"]*"|'[^']*')*) > \
               ((?:.|\n)*?) \
               <\/macro:\1>/x
   
    text.gsub(pattern) do |match|
      macro = MACROS[$1.to_sym]
      if macro
        attributes = {}
        xml_doc = REXML::Document.new("<tag #{$2} />")
        xml_doc.root.attributes.each {|a, b| attributes[a] = b }
        body = $3
        html = macro.expand(attributes, body)
      else
        html = CGI.escapeHTML(match)
      end
      filter.protect_html(html)
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
