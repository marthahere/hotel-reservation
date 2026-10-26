# Instructions for staff based on the reservation status
class FrontDeskNotifier
    INSTRUCTIONS = {
        "confirmed" => "New reservation confirmed. Please prepare room assignment.",
        "checked_in" => "Guest has checked in. Notify housekeeping to remove turndown service.",
        "checked_out" => "Guest has checked out. Flag room for housekeeping.",
        "do_not_disturb" => "Do Not Disturb active. Hold all housekeeping visits for this room.",
        "service_requested" => "Guest has requested service. Dispatch nearest available staff member."
    }

    def notify(reservation, event)
        formatted_time = event.timestamp.strftime("%Y-%m-%d %H:%M:%S")

        puts "----------------------------------------"
        puts "FRONT DESK ALERT"
        puts "----------------------------------------"
        puts "Reservation : #{reservation.confirmation_number}"
        puts "Status        : #{event.status}"
        puts "Location : #{event.location}"
        puts "Time          : #{formatted_time}"

        puts "Notes         : #{event.notes}" unless event.notes.nil? || event.notes.empty?

        puts "----------------------------------------"
        puts INSTRUCTIONS[event.status]
        puts "----------------------------------------"
    end
end