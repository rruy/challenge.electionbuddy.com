# frozen_string_literal: true
require 'test_helper'

class AnswerAuditTest < ActiveSupport::TestCase

  def setup
    @user = User.create!(email: 'ricardo.rruy@hotmail.com', password: '123456')
    @election = Election.create!(name: 'Election for Developer', start_at: Date.today, end_at: Date.today + 3.day, user_id: @user.id, author_user_id: @user.id)
    @question = Question.create!(name: 'Question 1', election_id: @election.id, author_user_id: @user.id)
  end

  test 'ensure audit after created new Answer' do 
    answer = Answer.create!(name: 'Answer 1', question_id: @question.id, author_user_id: @user.id);
    audit = Audit.last

    assert_equal audit.event, 'create'
    assert_equal audit.auditable_type, 'Answer'
    assert_equal audit.author_user_id, @user.id
    assert_equal JSON.parse(audit.trail)["id"], answer.id
  end

  test 'ensure audit after updated new Answer' do 
    answer = Answer.create!(name: 'Answer 1', question_id: @question.id, author_user_id: @user.id);
    answer.update(name: 'Ruy approved for Developer :)')
    audit = Audit.last

    assert_equal audit.event, 'update'
    assert_equal audit.auditable_type, 'Answer'
    assert_equal audit.author_user_id, @user.id
    assert_equal audit.auditable_id, answer.id
  end
end
