# frozen_string_literal: true

class AuditsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params['election_id'].present? 
        @election = Election.find_by(id: params['election_id'])

        @audits = Audit.where(auditable_type: "Election", auditable_id: params['election_id']).order(created_at: :desc)
        @questions = Question.where(election: params['election_id']).pluck(:id)
        @answers = Answer.where(question_id: @questions).pluck(:id)
  
        @audits_votes = Audit.where(auditable_type: "Voter", auditable_id: params['election_id']).order(created_at: :desc)
        @audits_questions = Audit.where(auditable_type: "Question", auditable_id: @questions).order(created_at: :desc)
        @audits_answers = Audit.where(auditable_type: "Answer", auditable_id: @answers).order(created_at: :desc)
    else
      @audits = Audit.all.order(created_at: :desc)
    end
  end
end
