module PasswordResetLimitable
  extend ActiveSupport::Concern

  included do
    before_save :check_password_reset_attempts, if: :will_save_change_to_reset_password_token?
  end

  def reset_password_attempts_exceeded?
    return false unless reset_password_attempted_at

    attempts = (reset_password_attempts || 0)
    time_since_first_attempt = Time.current - reset_password_attempted_at

    if time_since_first_attempt > 1.hour
      self.reset_password_attempts = 1
      self.reset_password_attempted_at = Time.current
      save(validate: false)
      false
    else
      attempts >= 5
    end
  end

  private

  def check_password_reset_attempts
    if reset_password_attempted_at.nil? || Time.current - reset_password_attempted_at > 1.hour
      self.reset_password_attempts = 1
      self.reset_password_attempted_at = Time.current
    else
      self.reset_password_attempts = (reset_password_attempts || 0) + 1
    end

    if reset_password_attempts_exceeded?
      errors.add(:base, 'Too many password reset attempts. Please try again later.')
      throw :abort
    end
  end
end 