class CalendarController < ApplicationController
  def index
    @selected_day = params[:day] || "Monday" # Default to Monday
    @time_slots = generate_time_slots
    @radio_jockeys = RadioJockey.all
    @daily_schedule = ScheduleEntry.where(day: @selected_day).order(:hour)
  end

  def generate_time_slots
    (0..23).map do |hour|
      start_time = "#{format('%02d', hour)}:00"
      end_time = hour == 23 ? "00:00" : "#{format('%02d', hour + 1)}:00"
      "#{start_time} - #{end_time}"
    end
  end
end
