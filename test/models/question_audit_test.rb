# frozen_string_literal: true
require 'test_helper'

class QuestionAuditTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: 'ricardo.rruy@hotmail.com', password: '123456')
    @election = Election.create!(name: 'Election for Developer', start_at: Date.today, end_at: Date.today + 3.day, user_id: @user.id, author_user_id: @user.id)
  end

  test 'ensure audit trail is created' do
    question = Question.create!(name: 'Question 1', election_id: @election.id, author_user_id: @user.id)
    audit = Audit.last

    assert_equal audit.event, 'create'
    assert_equal audit.auditable_type, 'Question'
    assert_equal JSON.parse(audit.trail)["id"], question.id
    assert_equal audit.author_user_id, @user.id
  end

  test 'ensure audit trail is updated' do
    question = Question.create!(name: 'Question 1', election_id: @election.id, author_user_id: @user.id)
    question.update!(name: 'Question 2', author_user_id: @user.id)

    audit = Audit.last
    assert_equal audit.event, 'update'
    assert_equal audit.auditable_type, 'Question'
    assert_equal audit.auditable_id, question.id
    assert_equal audit.author_user_id, @user.id
  end

  test 'ensure audit trail is deleted' do
    question = Question.create!(name: 'Question 1', election_id: @election.id, author_user_id: @user.id)
    question.destroy
    audit = Audit.last

    assert_equal audit.event, 'destroy'
    assert_equal audit.auditable_type, 'Question'
    assert_equal audit.auditable_id, question.id
    assert_equal audit.author_user_id, @user.id
  end
end