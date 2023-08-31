# frozen_string_literal: true
require 'test_helper'

class VoterAuditTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(email: 'ricardo.rruy@hotmail.com', password: '123456')
    @election = Election.create!(name: 'Election for Developer', start_at: Date.today, end_at: Date.today + 3.day, user_id: @user.id, author_user_id: @user.id)
    @question = Question.create!(name: 'Question 1', election_id: @election.id, author_user_id: @user.id)
  end

  test 'ensure audit after created new voter' do
    voter = Voter.create!(name: 'Vote approved', email: 'ricardo.rruy@hotmail.com', election_id: @election.id, author_user_id: @user.id)
    audit = Audit.last

    assert_equal audit.event, 'create'
    assert_equal audit.auditable_type, 'Voter'
    assert_equal JSON.parse(audit.trail)["id"], voter.id
    assert_equal audit.author_user_id, @user.id
  end

  test 'ensure audit after updated new voter' do
    voter = Voter.create!(name: 'Vote approved', email: 'ricardo.rruy@hotmail.com', election_id: @election.id, author_user_id: @user.id)
    voter.update(name: 'Vote approved 2')
    audit = Audit.last

    assert_equal audit.event, 'update'
    assert_equal audit.auditable_type, 'Voter'
    assert_equal audit.auditable_id, voter.id
    assert_equal audit.author_user_id, @user.id
  end

  test 'ensure audit after destroy voter' do
    voter = Voter.create!(name: 'Vote approved', email: 'ricardo.rruy@hotmail.com', election_id: @election.id, author_user_id: @user.id)
    voter.destroy
    audit = Audit.last

    assert_equal audit.event, 'destroy'
    assert_equal audit.auditable_type, 'Voter'
    assert_equal audit.auditable_id, voter.id
    assert_equal audit.author_user_id, @user.id
  end
end
