# frozen_string_literal: true

class Question < ApplicationRecord
  include Auditable
  audit_events

  belongs_to :election
  has_many :answers
end
