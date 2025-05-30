class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable
  ROLES = %w[admin trainer secretary].freeze

  has_one :trainer, dependent: :destroy
  # Validations
  validates :role, inclusion: { in: ROLES }

  # after_create :check_trainer!

  def admin?
    role == "admin"
  end

  def trainer?
    role == "trainer"
  end

  def secretary?
    role == "secretary"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id email encrypted_password role created_at updated_at
      sign_in_count current_sign_in_at last_sign_in_at
      current_sign_in_ip last_sign_in_ip
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "trainer" ]
  end

  private

  # def check_trainer!
  #   return unless self.trainer?

  #   Trainer.find_or_create_by!(admin_user_id: self.id)
  # end
end
