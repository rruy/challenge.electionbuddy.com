# frozen_string_literal: true

module Auditable
  extend ActiveSupport::Concern

  included do 
    attr_accessor :author_user_id
  end

  class_methods do 
    def audit_events
      after_create :record_create
      after_update :record_update
      after_destroy :record_destroy
    end
  end

  private

  def record_create
    data = parse_attributes(attributes, :create)
    Audit.create(data)
  end

  def record_update
    data = parse_attributes(previous_changes, :update)
    Audit.create(data)
  end

  def record_destroy
    data = parse_attributes(attributes, :destroy)
    Audit.create(data)
  end

  def parse_attributes(data, event)
    {
      auditable: self,
      trail: data.to_json,
      author_user_id: author_user_id,
      author_user_email: author_user_email,
      event: event.to_s
    }
  end

  def author_user_email
    User.find(author_user_id).try(:email)
  end
end