class CalendarController < ApplicationController
  def index
    @selected_day = params[:day] || "Monday" # Default to Monday
    @time_slots = generate_time_slots
    @radio_jockeys = RadioJockey.all
    @daily_schedule = ScheduleEntry.where(day: @selected_day).order(:hour)

<<<<<<< HEAD
    # Maybe move this below line to the app/services/scheduler_processor.rb
    # populate_schedule_entries #uncomment this line to call the function below to populate the tabe
=======
    populate_schedule_entries #uncomment this line to call the function below to populate the tabe
>>>>>>> e5601f7 (calendar_controller change)
  end

  private

  def generate_time_slots
    (0..23).map do |hour|
      "#{hour}:00 - #{hour + 1}:00"
    end
  end

<<<<<<< HEAD
  # Maybe move this below line to the app/services/scheduler_processor.rb
  # def populate_schedule_entries
  #  entry = ScheduleEntry.find_by(day: 'Monday', hour: 10)

  # Check if the entry exists and then update only the `show_name` field
  # entry.update(show_name: 'Morning Show') if entry.present?
  #  entry.update(last_name: 'Julian') if entry.present?
  #  entry.update(jockey_id: '18') if entry.present?

  #   @radio_jockeys.each do |jockey|
  #     # Apply the condition - update only if conditions are met (This condition must be set)
  #     if (1)
  #       # Find the existing ScheduleEntry for the given day and hour
  #       entry = ScheduleEntry.find_by(day: jockey.day, hour: jockey.hour)

  #       # Update the entry with new values if it exists
  #       if entry
  #         entry.update(
  #           show_name: jockey.show_name,
  #           last_name: jockey.last_name,
  #           jockey_id: jockey.id
  #         )
  #       end
  #     end
  #   end
  # end
=======
  def populate_schedule_entries
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
  end
>>>>>>> e5601f7 (calendar_controller change)
end
