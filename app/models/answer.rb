# frozen_string_literal: true

class Answer < ApplicationRecord
  include Auditable
  audit_events

  belongs_to :question
end
