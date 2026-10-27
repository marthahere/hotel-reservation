# Tests for Reservation, including status updates, event history,
# confirmation numbers, and notifier behavior.

require_relative "spec_helper"

RSpec.describe Reservation do
    # Set up a fresh reservation for each test
    let(:room) { SuiteRoom.new(204, 3) }
    let(:notifier) { double("Notifier", notify: nil) }
    let(:reservation) { Reservation.new("Carol", room, [notifier]) }

    describe "#initialize" do
        it "stores the guest name" do
            expect(reservation.guest_name).to eq("Carol")
        end

        
        it "generates a confirmation number with RES, a timestamp, and random digits" do
            expect(reservation.confirmation_number).to match(/\ARES\d{10,}\z/)
        end


        it "raises an error when no notifiers are provided" do
            expect {
                Reservation.new("Carol", room, [])
            }.to raise_error(
                ArgumentError,
                "At least one notifier is required"
            )
        end
    end

    describe "#current_status" do
        it "returns not_yet_confirmed when there are no events" do
            expect(reservation.current_status).to eq("not_yet_confirmed")
        end

        it "returns the latest status after an update" do
            reservation.update_status("confirmed", "Front Desk", Time.new(2025, 6, 15, 14, 0, 0))

            expect(reservation.current_status).to eq("confirmed")
        end
    end

    describe "#total_cost" do
        it "returns the room's total cost" do
            expect(reservation.total_cost).to eq(275)
        end
    end

    
    describe "#history" do
        it "starts with an empty history" do
            expect(reservation.history).to be_empty
        end

        it "stores events when the status changes" do
            time = Time.new(2025, 6, 15, 14, 0, 0)
            reservation.update_status("confirmed", "Front Desk", time)

            expect(reservation.history.length).to eq(1)
            expect(reservation.history.first.status).to eq("confirmed")
        end

        it "returns a copy of the history" do
            reservation.update_status(
            "confirmed",
            "Front Desk",
            Time.new(2025, 6, 15, 14, 0, 0)
            )

            history = reservation.history
            history.clear

            expect(reservation.history.length).to eq(1)
        end
    end

    describe "#update_status" do
        it "creates an event with the provided details" do
            time = Time.new(2025, 6, 15, 14, 0, 0)

            reservation.update_status(
                "confirmed",
                "Front Desk",
                time,
                "Booking complete"
            )

            event = reservation.history.first

            expect(event.status).to eq("confirmed")
            expect(event.location).to eq("Front Desk")
            expect(event.timestamp).to eq(time)
            expect(event.notes).to eq("Booking complete")
        end

        it "raises an error for an invalid status" do
            expect {
                reservation.update_status(
                "cancelled",
                "Front Desk",
                Time.new(2025, 6, 15, 14, 0, 0)
                )
            }.to raise_error(ArgumentError, "Invalid reservation status")
        end
    end

    
    describe "notifier behavior" do
        it "notifies each notifier when the status changes" do
            second_notifier = double("SecondNotifier", notify: nil)
            reservation = Reservation.new(
                "Carol",
                room,
                [notifier, second_notifier]
            )

            time = Time.new(2025, 6, 15, 14, 0, 0)
            reservation.update_status("confirmed", "Front Desk", time)

            expect(notifier).to have_received(:notify)
            expect(second_notifier).to have_received(:notify)
        end

        it "passes the reservation and event to the notifier" do
            time = Time.new(2025, 6, 15, 14, 0, 0)
            reservation.update_status("confirmed", "Front Desk", time)

            event = reservation.history.first

            expect(notifier).to have_received(:notify).with(reservation, event)
        end
    end

    
    it "keeps events in chronological order" do
        later_time = Time.new(2025, 6, 15, 15, 30, 0)
        earlier_time = Time.new(2025, 6, 15, 14, 0, 0)

        reservation.update_status("checked_in", "Room 204", later_time)
        reservation.update_status("confirmed", "Front Desk", earlier_time)

        expect(reservation.history.map(&:status)).to eq(
            ["confirmed", "checked_in"]
        )
    end

end
