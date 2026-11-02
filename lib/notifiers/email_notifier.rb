class EmailNotifier
    # Subject and opening message for each status
    EMAIL_DETAILS = {
        "confirmed" => [
            "Reservation Confirmed",
            "We're pleased to confirm your upcoming reservation."
        ],

        "checked_in" => [
            "Welcome to Grand Hotel!",
            "Your room is ready. We hope you enjoy every moment of your stay."
        ],

        "checked_out" => [
            "Thank you for staying with us",
            "We hope you had a wonderful stay. Your visit means a lot to us."
        ],

        "do_not_disturb" => [
            "Do Not Disturb Activated",
            "Your Do Not Disturb preference has been recorded."
        ],

        "service_requested" => [
            "Service Request Received",
            "Thank you for reaching out. Our team will be with you shortly."
        ]
    }

    def initialize(guest_email)
        @guest_email = guest_email
    end

    def notify(reservation, event)
        # Get the email content for the current status
        subject, opening = EMAIL_DETAILS[event.status]

        # Add the confirmation number to confirmation emails
        if event.status == "confirmed"
            subject = "#{subject} — #{reservation.confirmation_number}"
        end

        formatted_time = event.timestamp.strftime("%Y-%m-%d %H:%M:%S")

        puts "[Email to #{@guest_email}]:"
        puts "Subject: #{subject}"
        puts
        puts opening
        puts
        puts "Status   : #{event.status}"
        puts "Location : #{event.location}"
        puts "Time     : #{formatted_time}"

        # Only include notes when the guest provided them
        puts "Notes    : #{event.notes}" unless event.notes.nil? || event.notes.empty?

        puts "---"
        puts
    end
end