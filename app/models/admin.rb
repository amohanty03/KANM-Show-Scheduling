class Admin < ApplicationRecord
    enum role: { regular_user: 0, super_user: 1 }
    validates :email, presence: true, uniqueness: true
    validate :email_must_be_tamu
    validate :role_must_be_valid

    # Instance method for getting the role in human readable form
    def human_role_name
        I18n.t("activerecord.attributes.admin.roles.#{role}")
    end

    # Class method for getting the different roles in the human readable form
    def self.human_readable_roles
        roles.keys.map do |role|
          [I18n.t("activerecord.attributes.admin.roles.#{role}"), role]
        end
    end

    def email_must_be_tamu
      unless email =~ /\A[^@\s]+@tamu\.edu\z/
        errors.add(:email, "must be a TAMU email address ending with @tamu.edu")
      end
    end

    private # Following methods are private

    # This ensures that invalid admin roles are deemed invalid and handled without throwing an Argument error
    def role_must_be_valid
        errors.add(:role, "is not valid") unless role.in?(self.class.roles.keys)
    end
end
