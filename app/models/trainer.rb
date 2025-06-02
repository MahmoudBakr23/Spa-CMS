class Trainer < ApplicationRecord
  belongs_to :admin_user
  has_many :sessions, dependent: :destroy
  has_many :revenues, through: :sessions
  has_many :expenses

  scope :search_by_full_name, ->(query) {
    where("LOWER(first_name || ' ' || last_name) LIKE ?", "%#{query.downcase}%")
  }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    full_name.present? ? full_name : "Trainer ##{id}"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
     id first_name last_name phone created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "admin_user", "expenses", "revenues", "sessions" ]
  end
end
