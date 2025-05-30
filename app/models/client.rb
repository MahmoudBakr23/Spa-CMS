class Client < ApplicationRecord
  has_many :sessions, dependent: :destroy

  scope :search_by_full_name, ->(query) {
    where("LOWER(first_name || ' ' || last_name) LIKE ?", "%#{query.downcase}%")
  }

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
     id first_name last_name phone email created_at updated_at
    ]
  end
end
