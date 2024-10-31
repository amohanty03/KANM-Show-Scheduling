# app/services/schedule_processor.rb
# This Class will handle the core business logic of our Scheduler
class ScheduleProcessor
  def self.process
    puts "Handling the core scheduler business logic here."
    self.process_returning_rj_retaining_their_slots
    self.sort_and_assign_timeslots_for_remaining_rjs
  end


  # Step 1
  def self.process_returning_rj_retaining_their_slots
    @radio_jockeys = RadioJockey.all
    @radio_jockeys.each do |jockey|
      # Apply the condition - update only if conditions are met (This condition must be set)
      if (jockey.member_type == 'Returning DJ' and jockey.retaining == 'Yes')
        # Find the existing ScheduleEntry for the given day and hour
        entry = ScheduleEntry.find_by(day: jockey.day, hour: jockey.hour)

        # Update the entry with new values if it exists
        if entry
          entry.update(
            show_name: jockey.show_name,
            last_name: jockey.last_name,
            jockey_id: jockey.id
          )
        end
      end
    end
    # Extract all returning RJs who are retaining their slots, sorted just in case
    # Check if the schedule for the respective best(retained) slot is empty, if so save it
    # Else update the Database that the slot isn't retained anymore
    # But keep track of these RJs who didn't get their retained slot due to the conflict in some list
    # We will use this conflict list for highlighting in the final CSS, so that the website users are aware of the conflict
    puts "Processing returning RJ who've retaining their slots."
    # Required code here
  end

  # Step 2 and 3
  def self.sort_and_assign_timeslots_for_remaining_rjs
    puts "Processing all RJs who need to be assigned a new slot."

    # Read and Sort the RJs (Step 2)
    returning_rjs = RadioJockey.where(member_type: "Returning DJ", retaining: "no").order(
      semesters_in_KANM: :desc, expected_grad: :asc, timestamp: :asc
    )
    new_rjs = RadioJockey.where(member_type: "New DJ").order(
      semesters_in_KANM: :desc, expected_grad: :asc, timestamp: :asc
    )
    sorted_rjs = returning_rjs + new_rjs

    # (Step 3)
    # For each RJ, check first for their best slot being free in the schedule, populate if true, continue
    # If not, then get all the available slots, and find one which is free in the schedule, populate and continue
    # If this too failed, then add to the list of unassigned RJs, that we will display in the frontend
    sorted_rjs.each do |rj|
      puts format(
        "UIN: %-11s\tDJ Name: %-15s Member Type: %-15s Semesters in KANM: %-5s Expected Graduation: %-8s Timestamp: %-20s",
        rj.UIN, rj.DJ_name, rj.member_type, rj.semesters_in_KANM, rj.expected_grad, rj.timestamp
      )
      # Required code here
    end
  end
end
