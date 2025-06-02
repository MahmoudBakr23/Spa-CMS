class Service < ApplicationRecord
  has_many :sessions

  def to_s
    name.present? ? name : "Service ##{id}"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
     id name price duration created_at updated_at
    ]
  end
end
