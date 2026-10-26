# Load the classes needed for the demo
require_relative "../lib/rooms/suite_room"
require_relative "../lib/reservation"
require_relative "../lib/notifiers/text_notifier"
require_relative "../lib/notifiers/email_notifier"
require_relative "../lib/notifiers/front_desk_notifier"

puts "=== Hotel Reservation Management System Demo ==="
puts

# Create a room for the guest
puts "Creating room..."
room = SuiteRoom.new(204, 3)
puts room.description
puts
puts "Estimated stay cost: $#{format("%.2f", room.cost)}"
puts

# Set up the 3 notification methods
puts "Creating reservation with all notifiers..."
notifiers = [
TextNotifier.new("555-0192"),
EmailNotifier.new("carol@example.com"),
FrontDeskNotifier.new
]

reservation = Reservation.new("Carol", room, notifiers)

puts "Reservation created: #{reservation.confirmation_number} (Guest: #{reservation.guest_name})"
puts
puts "Tracking guest journey..."
puts

# Record the guest's reservation events
events = [
["confirmed", "Front Desk", Time.new(2025, 6, 15, 14, 0, 0)],
["checked_in", "Room 204", Time.new(2025, 6, 15, 15, 30, 0)]
]

events.each do |status, location, timestamp|
puts "--- #{status} ---"

reservation.update_status(status, location, timestamp)
puts
end

# Display the final reservation information
puts "Current status: #{reservation.current_status}"
puts "Total events: #{reservation.history.length}"
puts
puts "Demo complete!"