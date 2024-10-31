class CalendarController < ApplicationController
  def index
    @selected_day = params[:day] || "Monday" # Default to Monday
    @time_slots = generate_time_slots
    @radio_jockeys = RadioJockey.all
    @daily_schedule = ScheduleEntry.where(day: @selected_day).order(:hour)
  end

  def generate_time_slots
    (0..23).map do |hour|
      "#{hour}:00 - #{hour + 1}:00"
    end
  end
end
