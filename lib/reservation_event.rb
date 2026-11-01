class ReservationEvent
    VALID_STATUSES = [
        "confirmed",
        "checked_in",
        "checked_out",
        "do_not_disturb",
        "service_requested"
    ].freeze

    attr_reader :status, :location, :timestamp, :notes

    def initialize(status, location, timestamp, notes = nil)
        unless VALID_STATUSES.include?(status)
            raise ArgumentError, "Invalid reservation status"
        end

        @status = status.dup.freeze
        @location = location.dup.freeze
        @timestamp = timestamp.dup.freeze
        @notes = notes&.dup&.freeze

        freeze
    end

    def to_s
        formatted_time = timestamp.strftime("%Y-%m-%d %H:%M:%S")
        "[#{formatted_time}] #{status} at #{location}"
    end
end