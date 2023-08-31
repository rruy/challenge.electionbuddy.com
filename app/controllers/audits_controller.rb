# frozen_string_literal: true

class AuditsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params['election_id'].present? 
      @audits = Audit.where(auditable_type: "Election", auditable_id: params['election_id']).order(created_at: :desc)
    else
      @audits = Audit.all.order(created_at: :desc)
    end
  end
end
