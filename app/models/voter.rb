# frozen_string_literal: true

class Voter < ApplicationRecord
  include Auditable
  audit_events

  belongs_to :election
end
