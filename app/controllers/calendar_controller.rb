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

  def export
    @selected_day = params[:day]
    @time_slots = generate_time_slots # Example time slots, adjust as needed
    @daily_schedule = ScheduleEntry.where(day: @selected_day) # Example query, adjust as needed

    # Create an Excel package
    package = Axlsx::Package.new
    workbook = package.workbook

    # Add a worksheet to the workbook
    workbook.add_worksheet(name: "#{@selected_day} Schedule") do |sheet|
      # Add header row
      sheet.add_row [ "Time Slot", "Show Name", "Last Name", "Jockey ID" ]

      # Add each time slot and details to the sheet
      @time_slots.each_with_index do |slot, index|
        entry = @daily_schedule.find { |e| e.hour == index }
        show_name = entry&.show_name || "Empty"
        last_name = entry&.last_name || "Empty"
        jockey_id = entry&.jockey_id || "Empty"

        sheet.add_row [ slot, show_name, last_name, jockey_id ]
      end
    end

    # Send the file to the user
    file_name = "#{@selected_day}_schedule.xlsx"
    send_data package.to_stream.read, filename: file_name, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end
end
