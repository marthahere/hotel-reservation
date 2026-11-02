class TextNotifier
    MESSAGES = {
        "confirmed" => "Your reservation at Grand Hotel is confirmed. See you soon!",
        "checked_in" => "You're checked in! Enjoy your stay at Grand Hotel.",
        "checked_out" => "Thanks for staying with us. Safe travels!",
        "do_not_disturb" => "Do Not Disturb is active for your room.",
        "service_requested" => "We've received your service request and are on our way."
    }

    def initialize(phone_number)
        @phone_number = phone_number
    end

    # Sends a text message based on the reservation status
    def notify(reservation, event)
        message = MESSAGES[event.status]
        puts "[SMS to #{@phone_number}]: #{message}"
        puts
    end
    
end