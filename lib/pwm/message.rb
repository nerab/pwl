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

    def initialize(template, exit_code = 0, default_replacements = {})
      @template = ERB.new(template)
      @exit_code = exit_code
      @default_replacements = default_replacements
    end

    def to_s(replacements = {})
      if !replacements.any? && @default_replacements.any?
        @template.result(@default_replacements.to_binding)
      else
        @template.result(replacements.to_binding)
      end
    end

    def error?
      false
    end
  end

  class ErrorMessage < Message
    def initialize(template, exit_code, default_replacements = {})
      raise ReservedMessageCodeError.new("Exit code 0 is reserved for success messages") if 0 == exit_code
      super(template, exit_code, default_replacements)
    end

    def error?
      true
    end
  end
end
