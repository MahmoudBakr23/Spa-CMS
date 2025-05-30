class Session < ApplicationRecord
  STATUSES = %w[expired upcoming performed refunded].freeze

  belongs_to :client
  belongs_to :service
  belongs_to :trainer
  has_one :revenue, dependent: :destroy

  validates :status, inclusion: { in: STATUSES }

  after_create :create_revenue!

  def expired?
    status == "expired"
  end

  def active?
    status == "active"
  end

  def performed?
    status == "performed"
  end

  def refunded?
    status == "refunded"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
     id perform_at status notes created_at updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "client", "revenue", "service", "trainer" ]
  end

  private

  def create_revenue!
    Revenue.create!(amount: self.service.price, session_id: self.id)
  end
end
