require "erb"

# http://refactormycode.com/codes/281-given-a-hash-of-variables-render-an-erb-template
class Hash
  def to_binding(object = Object.new)
    object.instance_eval("def binding_for(#{keys.join(",")}) binding end")
    object.binding_for(*values)
  end
end

module Pwm
  class ReservedMessageCodeError < StandardError; end

  class Message
    attr_reader :exit_code

    def initialize(template, exit_code = 0)
      @template = ERB.new(template)
      @exit_code = exit_code
    end

    def to_s(replacements = {})
      @template.result(replacements.to_binding)
    end

    def error?
      false
    end
  end

  class ErrorMessage < Message
    def initialize(template, exit_code)
      raise ReservedMessageCodeError.new("Exit code 0 is reserved for success messages") if 0 == exit_code
      super(template, exit_code)
    end

    def to_s(replacements = {})
      "Error: #{super(replacements)}"
    end

    def error?
      true
    end
  end
end
