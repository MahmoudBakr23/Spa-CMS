class Expense < ApplicationRecord
  CATEGORIES = %w[other asset salary bonus deduction].freeze

  belongs_to :trainer, optional: true

  validates :category, inclusion: { in: CATEGORIES }

  def other?
    category == "other"
  end

  def asset?
    category == "asset"
  end

  def salary?
    category == "salary"
  end

  def bonus?
    category == "bonus"
  end

  def deduction?
    category == "deduction"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id name amount occurred_on category notes created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "trainer" ]
  end
end
