class EventMailer < ApplicationMailer
  def cancelled(params)
    @user = params[:user]
    @event = params[:event]
    mail(to: @user.email, subject: 'Event Cancelled')
  end
end
