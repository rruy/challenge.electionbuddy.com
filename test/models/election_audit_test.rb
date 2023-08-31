require 'test_helper'

class ElectionAuditTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: 'ricardo.rruy@hotmail.com', password: '123456')
  end

  test 'ensure audit after created new Election' do
    election = Election.create!(name: 'Election for Developer', start_at: Date.today, end_at: Date.today + 3.day, user_id: @user.id, author_user_id: @user.id)
    audit = Audit.last

    assert_equal audit.event, 'create'
    assert_equal audit.auditable_type, 'Election'
    assert_equal audit.auditable_id, election.id
    assert_equal audit.author_user_id, @user.id
  end

  test 'ensure audit after updated new Election' do
    election = Election.create!(name: 'Election for Developer', start_at: Date.today, end_at: Date.today + 3.day, user_id: @user.id, author_user_id: @user.id)
    election.update(name: 'Ruy for Delevoper at Election Buddy')
    audit = Audit.last

    assert_equal audit.event, 'update'
    assert_equal audit.auditable_type, 'Election'
    assert_equal audit.auditable_id, election.id
    assert_equal audit.author_user_id, @user.id
  end

  test 'ensure audit after destroy Election' do
    election = Election.create!(name: 'Election for Developer', start_at: Date.today, end_at: Date.today + 3.day, user_id: @user.id, author_user_id: @user.id)
    election.destroy
    audit = Audit.last

    assert_equal audit.event, 'destroy'
    assert_equal audit.auditable_type, 'Election'
    assert_equal audit.auditable_id, election.id
    assert_equal audit.author_user_id, @user.id
  end
end