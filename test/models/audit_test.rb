require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: 'ricardo.rruy@hotmail.com', password: '123456')
  end
  test 'should belong to auditable' do
    assert_respond_to Audit.new, :auditable
  end

  test 'should not be valid without auditable' do
    audit = Audit.new(author_user_id: @user.id, event: 'Create', trail: '{}')
    assert_not audit.valid?
    assert_includes audit.errors.full_messages, "Auditable can't be blank"
  end

  test 'should not be valid without author_user' do
    audit = Audit.new(auditable: audits(:one), event: 'Create', trail: '{}')
    assert_not audit.valid?
    assert_includes audit.errors.full_messages, "Author user can't be blank"
  end

  test 'should not be valid without event' do
    audit = Audit.new(auditable: audits(:one), author_user_id: @user.id, trail: '{}')
    assert_not audit.valid?
    assert_includes audit.errors.full_messages, "Event can't be blank"
  end

  test 'should not be valid without body' do
    audit = Audit.new(auditable: audits(:one), author_user_id: @user.id, trail: 'Create')
    assert_not audit.valid?
    assert_includes audit.errors.full_messages, "Event can't be blank"
  end
end
