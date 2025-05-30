class Revenue < ApplicationRecord
  belongs_to :session

  def self.ransackable_attributes(auth_object = nil)
    %w[
     id amount created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "session" ]
  end
end
