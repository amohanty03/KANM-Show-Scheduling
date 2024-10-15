require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { Admin.new(email: 'test@tamu.edu', role: 'super_user') }

  describe '#human_role_name' do
    it 'returns the human-readable role name' do
      expect(admin.human_role_name).to eq(I18n.t("activerecord.attributes.admin.roles.super_user"))
    end
  end

  describe '.human_readable_roles' do
    it 'returns all roles in human-readable form' do
      expected_roles = Admin.roles.keys.map do |role|
        [ I18n.t("activerecord.attributes.admin.roles.#{role}"), role ]
      end
      expect(Admin.human_readable_roles).to match_array(expected_roles)
    end
  end
end
