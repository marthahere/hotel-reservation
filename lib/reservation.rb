require_relative "reservation_event"

class Reservation
    attr_reader :guest_name, :confirmation_number

    def initialize(guest_name, room, notifiers)
        if notifiers.empty?
            raise ArgumentError, "At least one notifier is required"
        end

        @guest_name = guest_name
        @room = room
        @notifiers = notifiers
        @events = []

        # Add random digits so reservations created around the same time differ
        @confirmation_number = "RES#{Time.now.to_i}#{rand(1000..9999)}"
    end

    def current_status
        # No events means the reservation hasn't been confirmed yet
        return "not_yet_confirmed" if @events.empty?
        
        @events.last.status
    end

    def history
        @events.dup
    end

    def total_cost
        @room.cost
    end

    def update_status(status, location, timestamp, notes = nil)
        event = ReservationEvent.new(status, location, timestamp, notes)
        @events << event
        @events.sort_by!(&:timestamp)
        
        @notifiers.each do |notifier|
            notifier.notify(self, event)
        end
    end
end