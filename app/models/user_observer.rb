class UserObserver < ActiveRecord::Observer
  observe :user_observer


  def after_create(user)
    UserNotifier.deliver_signup_notification(user)
  end

  def after_save(user)
  end
end