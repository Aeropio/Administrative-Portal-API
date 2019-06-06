class User < ApplicationRecord
	# encrypt password
  has_many :tags
  has_secure_password
  # email is not editable 
  attr_readonly :email



  # Model associations
  # has_many :tags, foreign_key: :created_by
  # Validations
  validate :email_id_not_changed
  validates_presence_of :name, :email, :password_digest

  def email_id_not_changed
    if email_changed? && self.persisted?
      errors.add(:email_id, "Change of email_id not allowed!")
    end
  end

end
