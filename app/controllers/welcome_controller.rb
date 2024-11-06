class WelcomeController < ApplicationController
  def index
    # Use a different directory in test environment to isolate real data
    upload_path = Rails.env.test? ? "#{Rails.root}/tmp/test_uploads" : "#{Rails.root}/public/uploads"

    # Check for CSV and XLSX files in the specified directory
    @csv_files = Dir.glob("#{upload_path}/*.{csv,xlsx}")
  end

  def handle_files
    case params[:action_type]
    when "Generate Schedule"
      handle_generate_schedule
    when "Delete Selected Files"
      handle_delete_selected_files
    else
      redirect_invalid_action
    end
  end

  private

  def handle_generate_schedule
    selected_files = params[:selected_files]
    if valid_file_selection?(selected_files)
      parse_selected_files(selected_files)
    else
      redirect_to welcome_path, alert: "Please select exactly one file to parse."
    end
  end

  def valid_file_selection?(selected_files)
    selected_files.present? && selected_files.size == 1
  end

  def handle_delete_selected_files
    if params[:selected_files].present?
      delete_csv_files(params[:selected_files])
      redirect_to welcome_path, notice: "Selected files have been deleted."
    else
      redirect_to welcome_path, alert: "No files selected for deletion."
    end
  end

  def redirect_invalid_action
    redirect_to welcome_path, alert: "Invalid action."
  end


  private

  def delete_csv_files(selected_files)
    upload_path = determine_upload_path

    return unless params[:selected_files].present?

    params[:selected_files].each do |file_name|
      delete_file(upload_path, file_name)
    end
  end

  private

  def determine_upload_path
    Rails.env.test? ? "#{Rails.root}/tmp/test_uploads" : "#{Rails.root}/public/uploads"
  end

  def delete_file(upload_path, file_name)
    file_path = Rails.root.join(upload_path, file_name)

    if File.exist?(file_path)
      File.delete(file_path)
    end
  end


  def parse_selected_files(selected_files)
    upload_path = Rails.env.test? ? "#{Rails.root}/tmp/test_uploads" : "#{Rails.root}/public/uploads"

    selected_files.each do |file_name|
      file_path = Rails.root.join(upload_path, file_name)
      begin
        parse_and_create_radio_jockeys(file_path)
      rescue StandardError => e
        Rails.logger.error("Error while parsing XLSX: #{e.message}")
        flash[:alert] = "An error occurred during file parsing."
        redirect_to welcome_path and return
      end
      ScheduleProcessor.process
    end
    redirect_to calendar_path
  end

  def parse_and_create_radio_jockeys(file_path)
    RadioJockey.delete_all
    ScheduleEntry.delete_all
    %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].each do |day|
      (0..23).each do |hour|
        ScheduleEntry.create(day: day, hour: hour, show_name: nil, last_name: nil, jockey_id: nil)
      end
    end

    xlsx = Roo::Spreadsheet.open(file_path.to_s)

    # process_sheet(xlsx.sheet(0), "Returning DJ", returning_dj_attributes, xlsx)
    # process_sheet(xlsx.sheet(1), "New DJ", new_dj_attributes, xlsx)
    process_sheet(xlsx.sheet(0), "Returning DJ", xlsx, header_mapping)
    process_sheet(xlsx.sheet(1), "New DJ", xlsx, header_mapping)
  end

  private

  # def process_sheet(sheet, dj_type, attributes, xlsx, header_mapping)
  def process_sheet(sheet, dj_type, xlsx, header_mapping)
    headers = xlsx.row(1)

    column_mapping = {} # Create a mapping between headers and column indices
    headers.each_with_index do |header, index|
      column_mapping[header.strip.downcase] = index
    end

    i = 1
    sheet.each_row_streaming(offset: 1) do |row| # Skip header row
      i += 1
      if row[column_mapping[header_mapping[:member_type]]].to_s == dj_type
        create_radio_jockey(row, i, xlsx, column_mapping, header_mapping)
        # create_radio_jockey(row, i, attributes, xlsx, column_mapping, header_mapping)
      end
    end
  end

  def convert_to_24_hr_format(time)
    # raise ArgumentError, "Best Hour cannot be nil, please fix the spreadsheet" if time.nil?
    hour, ampm = time.split(" ")
    if hour == "12"
      return ampm == "AM" ? "0" : "12"
    else
      return ampm == "AM" ? hour : (hour.to_i + 12).to_s
    end
  end

  def format_times(times)
    times = times.split(",")
    converted_times = []
    times.each do |time| 
      converted_time = convert_to_24_hr_format(time)
      converted_times << converted_time
    end
    converted_times = converted_times.join(";")
    converted_times
  end

  def create_radio_jockey(row, row_index, xlsx, column_mapping, header_mapping)
    # def create_radio_jockey(row, row_index, attributes, xlsx, column_mapping, header_mapping)
    # best_hour_string = (row[column_mapping[header_mapping[:best_hour]]] || "").to_f
    # best_hour = (best_hour_string * 24).round.to_s
    # expected_grad_year = row[attributes[:grad_year_column]]&.value.to_s || ""
    # expected_grad_month = row[attributes[:grad_month_column]]&.value.to_s || ""
    # show_name = row[attributes[:show_name_column]]&.value.to_s || ""

    best_hour_string = row[column_mapping[header_mapping[:best_hour]]].to_s || ""
    best_hour = convert_to_24_hr_format(best_hour_string)
    expected_grad_year = row[column_mapping[header_mapping[:graduating_year]]].to_s || ""
    expected_grad_month = row[column_mapping[header_mapping[:graduating_month]]].to_s || ""
    show_name = row[column_mapping[header_mapping[:show_name]]].to_s || ""
    retaining = column_mapping.key?(header_mapping[:retaining]) ? row[column_mapping[header_mapping[:retaining]]].to_s || "No" : "No"


    unless RadioJockey.exists?(show_name: show_name)
      RadioJockey.create!(
        # timestamp: row[attributes[:timestamp_column]]&.value.to_s || "",
        # first_name: row[attributes[:first_name_column]]&.value.to_s || "",
        # last_name: row[attributes[:last_name_column]]&.value.to_s || "",
        # uin: row[attributes[:uin_column]]&.value.to_s || "",
        # member_type: row[attributes[:member_type_column]]&.value.to_s || "",
        # retaining: attributes[:retaining] || row[attributes[:retaining_column]]&.value.to_s || "",
        # semesters_in_kanm: row[attributes[:semesters_column]]&.value.to_s || "",
        # dj_name: row[attributes[:dj_name_column]]&.value.to_s || "",
        # best_day: row[attributes[:best_day_column]]&.value.to_s || "",
        # **weekly_availability(row_index, attributes[:weekly_columns], xlsx),
        # **unavailability(row_index, attributes[:unavailability_columns], xlsx)
        # timestamp: row[column_mapping[header_mapping[:timestamp]]].to_s || "",
        timestamp: row[column_mapping[header_mapping[:timestamp]]].value.to_s || "",
        first_name: row[column_mapping[header_mapping[:first_name]]].to_s || "",
        last_name: row[column_mapping[header_mapping[:last_name]]].to_s || "",
        uin: row[column_mapping[header_mapping[:uin]]].to_s || "",
        expected_grad: "#{expected_grad_year}/#{expected_grad_month}",
        member_type: row[column_mapping[header_mapping[:member_type]]].to_s || "",
        retaining: retaining,
        semesters_in_kanm: row[column_mapping[header_mapping[:semesters_in_kanm]]].to_s || "0",
        show_name: show_name,
        dj_name: row[column_mapping[header_mapping[:dj_name]]].to_s || "",
        best_day: row[column_mapping[header_mapping[:best_day]]].to_s || "",
        best_hour: best_hour,

        alt_mon: format_times(row[column_mapping[header_mapping[:alt_mon]]].to_s || ""),
        alt_tue: format_times(row[column_mapping[header_mapping[:alt_tue]]].to_s || ""),
        alt_wed: format_times(row[column_mapping[header_mapping[:alt_wed]]].to_s || ""),
        alt_thu: format_times(row[column_mapping[header_mapping[:alt_thu]]].to_s || ""),
        alt_fri: format_times(row[column_mapping[header_mapping[:alt_fri]]].to_s || ""),
        alt_sat: format_times(row[column_mapping[header_mapping[:alt_sat]]].to_s || ""),
        alt_sun: format_times(row[column_mapping[header_mapping[:alt_sun]]].to_s || ""),

        un_jan: row[column_mapping[header_mapping[:un_jan]]].to_s || "",
        un_feb: row[column_mapping[header_mapping[:un_feb]]].to_s || "",
        un_mar: row[column_mapping[header_mapping[:un_mar]]].to_s || "",
        un_apr: row[column_mapping[header_mapping[:un_apr]]].to_s || "",
        un_may: row[column_mapping[header_mapping[:un_may]]].to_s || "",
      )
    end
  end

  def header_mapping
    {
      timestamp: "timestamp",
      first_name: "first name",
      last_name: "last name",
      show_name: "show name",
      graduating_year: "graduating year",
      graduating_month: "graduating month",
      retaining: "retain slot",
      semesters_in_kanm: "semesters in kanm",
      member_type: "select position applying for:",
      uin: "uin",
      dj_name: "dj name",
      best_day: "best day",
      best_hour: "best hour",

      alt_mon: "alternative timeslots [monday]",
      alt_tue: "alternative timeslots [tuesday]",
      alt_wed: "alternative timeslots [wednesday]",
      alt_thu: "alternative timeslots [thursday]",
      alt_fri: "alternative timeslots [friday]",
      alt_sat: "alternative timeslots [saturday]",
      alt_sun: "alternative timeslots [sunday]",

      un_jan: "unavailable dates [january]",
      un_feb: "unavailable dates [february]",
      un_mar: "unavailable dates [march]",
      un_apr: "unavailable dates [april]",
      un_may: "unavailable dates [may]",
      un_jun: "unavailable dates [june]",

      un_jul: "unavailable dates [july]",
      un_aug: "unavailable dates [august]",
      un_sep: "unavailable dates [september]",
      un_oct: "unavailable dates [october]",
      un_nov: "unavailable dates [november]",
      un_dec: "unavailable dates [december]",
    }
  end

  # def weekly_availability(row_index, weekly_columns, xlsx)
  #   {
  #     alt_mon: xlsx.cell(weekly_columns[:mon], row_index).to_s,
  #     alt_tue: xlsx.cell(weekly_columns[:tue], row_index).to_s,
  #     alt_wed: xlsx.cell(weekly_columns[:wed], row_index).to_s,
  #     alt_thu: xlsx.cell(weekly_columns[:thu], row_index).to_s,
  #     alt_fri: xlsx.cell(weekly_columns[:fri], row_index).to_s,
  #     alt_sat: xlsx.cell(weekly_columns[:sat], row_index).to_s,
  #     alt_sun: xlsx.cell(weekly_columns[:sun], row_index).to_s
  #   }
  # end

  # def unavailability(row_index, unavailability_columns, xlsx)
  #   {
  #     un_jan: xlsx.cell(unavailability_columns[:jan], row_index).to_s,
  #     un_feb: xlsx.cell(unavailability_columns[:feb], row_index).to_s,
  #     un_mar: xlsx.cell(unavailability_columns[:mar], row_index).to_s,
  #     un_apr: xlsx.cell(unavailability_columns[:apr], row_index).to_s,
  #     un_may: xlsx.cell(unavailability_columns[:may], row_index).to_s
  #   }
  # end

  # def returning_dj_attributes
  #   {
  #     timestamp_column: 0, first_name_column: 4, last_name_column: 5, uin_column: 8,
  #     grad_year_column: 9, grad_month_column: 10, member_type_column: 14,
  #     retaining_column: 15, semesters_column: 16, show_name_column: 23,
  #     dj_name_column: 24, best_day_column: 26, best_hour_column: 27,
  #     weekly_columns: { mon: "AC", tue: "AD", wed: "AE", thu: "AF", fri: "AG", sat: "AH", sun: "AI" },
  #     unavailability_columns: { jan: "AJ", feb: "AK", mar: "AL", apr: "AM", may: "AN" }
  #   }
  # end

  # def new_dj_attributes
  #   {
  #     timestamp_column: 0, first_name_column: 5, last_name_column: 6, uin_column: 10,
  #     grad_year_column: 13, grad_month_column: 14, member_type_column: 22,
  #     retaining: "No", semesters_column: 20, show_name_column: 32,
  #     dj_name_column: 33, best_day_column: 35, best_hour_column: 36,
  #     weekly_columns: { mon: "AL", tue: "AM", wed: "AN", thu: "AO", fri: "AP", sat: "AQ", sun: "AR" },
  #     unavailability_columns: { jan: "AS", feb: "AT", mar: "AU", apr: "AV", may: "AW" }
  #   }
  # end
end
