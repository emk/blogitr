module Blogitr
  MACROS = {}

  def self.register_macro name, macro_class
    MACROS[name] = macro_class.new
  end

  class Macro
    def expand options, body
      raise "You must override Macro#filter"
    end
  end
end
