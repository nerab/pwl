module Pwl
  class InvalidMasterPasswordError < StandardError
    def initialize(reason)
      super("The master password is not valid: #{reason}")
    end
  end

  class AnyNonEmptyPasswordPolicy
    def validate!(master_password)
      raise InvalidMasterPasswordError.new("Password must not be blank") if master_password.blank?
    end
  end

  class ForbidAllPasswordPolicy
    def validate!(master_password)
      raise InvalidMasterPasswordError.new("No password allowed at all")
    end
  end

  class ReasonableComplexityPasswordPolicy
    def validate!(pwd)
      raise InvalidMasterPasswordError.new("May not be blank") if pwd.blank?
      raise InvalidMasterPasswordError.new("Must have at least eight characters") if 8 > pwd.length
      raise InvalidMasterPasswordError.new("Must contain at least one integer") unless pwd =~ /.*\d/
      raise InvalidMasterPasswordError.new("Must contain at least one character (lower or upper case)") unless pwd =~ /.*([a-z]|[A-Z])/
      raise InvalidMasterPasswordError.new("Special characters are only allowed if their ASCII value is between 0x20 and 0x7E") unless pwd =~ /[\x20-\x7E]/
    end
  end
end
