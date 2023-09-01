class EventMailer < ApplicationMailer
  def cancelled(params)
    @event = params[:event]
    mail(
      to: @event.organizer.email,
      bcc: @event.attendees.pluck(:email),
      subject: 'Event Cancelled'
    )
  end
end
