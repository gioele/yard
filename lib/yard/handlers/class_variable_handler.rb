class YARD::Handlers::ClassVariableHandler < YARD::Handlers::Base
  HANDLER_MATCH = /\A@@\S*\s*=\s*/m
  handles HANDLER_MATCH
  
  def process
    # Don't document @@cvars if they're set in second class objects (methods) because
    # they're not "static" when executed from a method
    return unless owner.is_a? NamespaceObject
    
    name, value = *statement.tokens.to_s.gsub(/\r?\n/, '').split(/\s*=\s*/, 2)
    namespace.cvars << ClassVariableObject.new(namespace, name) do |o|
      o.docstring = statement.comments
      o.source = statement
      o.file = parser.file
    end
  end
end