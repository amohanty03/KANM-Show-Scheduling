require 'axlsx'
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

    days_of_week.each do |day|
      daily_schedule = ScheduleEntry.where(day: day)

      workbook.add_worksheet(name: "#{day}") do |sheet|
        sheet.add_row [ "Time Slot", "Show Name" ]

        @time_slots.each_with_index do |slot, index|
          entry = daily_schedule.find { |e| e.hour == index }
          show_name = entry&.show_name || ""
          sheet.add_row [ slot, show_name ]
        end
      end
    end

    file_name = "Weekly_Schedule.xlsx"
    send_data package.to_stream.read, filename: file_name, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def download_unassigned_rjs
    unassigned_rjs = ScheduleProcessor.unassigned_rjs 

    package = Axlsx::Package.new

    package.workbook.add_worksheet(name: "Unassigned RJs") do |sheet|
      sheet.add_row ["UIN", "First Name", "Last Name", "DJ Name", "Member Type", "Semesters in KANM", "Expected Graduation", "Timestamp", "Show Name"]

      unassigned_rjs.each do |rj|
        sheet.add_row [rj.uin, rj.first_name, rj.last_name, rj.dj_name, rj.member_type, rj.semesters_in_kanm, rj.expected_grad, rj.timestamp, rj.show_name]
      end
    end

    send_data package.to_stream.read, filename: "unassigned_rjs.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

end
