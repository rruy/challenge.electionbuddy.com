class Audit < ApplicationRecord
  belongs_to :auditable, polymorphic: true

  validates :auditable, :author_user_id, :author_user_email, :event, :trail, presence: true
end

