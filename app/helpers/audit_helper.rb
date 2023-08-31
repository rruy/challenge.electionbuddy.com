# frozen_string_literal: true

module AuditHelper
  def parse_audit_data(data)
    data = JSON.parse(data)
    data.delete('created_at')
    data.delete('updated_at')
    data
  end
end
