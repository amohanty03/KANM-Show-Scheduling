require "axlsx"
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
    @time_slots = generate_time_slots
    days_of_week = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday]

    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Weekly Schedule") do |sheet|
      sheet.add_row([ "Time Slot" ] + days_of_week)

      @time_slots.each_with_index do |slot, index|
        row = [ slot ]
        days_of_week.each do |day|
          entry = ScheduleEntry.where(day: day, hour: index).first
          show_name = entry&.show_name || ""
          row << show_name
        end
        sheet.add_row(row)
      end
    end

    file_name = "Weekly_Schedule.xlsx"
    send_data package.to_stream.read, filename: file_name, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def format_time_list(time_list_str)
    return "" if time_list_str.nil? || time_list_str.empty?

    time_list_str.split(";").map { |hour| "#{hour.to_i.to_s.rjust(2, '0')}:00" }.join(";")
  end


  def download_unassigned_rjs
    unassigned_rjs = ScheduleProcessor.unassigned_rjs

    package = Axlsx::Package.new

    package.workbook.add_worksheet(name: "Unassigned RJs") do |sheet|
      sheet.add_row [ "UIN", "First Name", "Last Name", "DJ Name", "Member Type", "Semesters in KANM", "Expected Graduation", "Timestamp", "Show Name", "Best Day", "Best Hour", "Alternative Timeslots [Monday]", "Alternative Timeslots [Tuesday]", "Alternative Timeslots [Wednesday]", "Alternative Timeslots [Thursday]", "Alternative Timeslots [Friday]", "Alternative Timeslots [Saturday]", "Alternative Timeslots [Sunday]" ]

      unassigned_rjs.each do |rj|
        formatted_best_hour = "#{rj.best_hour.to_i.to_s.rjust(2, '0')}:00"
        sheet.add_row [ rj.uin, rj.first_name, rj.last_name, rj.dj_name, rj.member_type, rj.semesters_in_kanm, rj.expected_grad, rj.timestamp, rj.show_name, rj.best_day, formatted_best_hour, format_time_list(rj.alt_mon), format_time_list(rj.alt_tue), format_time_list(rj.alt_wed), format_time_list(rj.alt_thu), format_time_list(rj.alt_fri), format_time_list(rj.alt_sat), format_time_list(rj.alt_sun) ]
      end
    end

    send_data package.to_stream.read, filename: "unassigned_rjs.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end
end
