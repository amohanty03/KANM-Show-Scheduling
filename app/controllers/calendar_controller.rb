class CalendarController < ApplicationController
  def index
    @selected_day = params[:day] || "Monday" # Default to Monday
    @time_slots = generate_time_slots
  end

  private

  def generate_time_slots
    (0..23).map do |hour|
      "#{hour}:00 - #{hour + 1}:00"
    end
  end
end
