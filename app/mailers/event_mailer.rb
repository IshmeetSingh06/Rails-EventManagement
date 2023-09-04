class EventMailer < ApplicationMailer
  def cancelled(event)
    @event = event
    mail(
      to: @event.organizer.email,
      bcc: @event.attendees.pluck(:email),
      subject: 'Event Cancelled'
    )
  end
end
