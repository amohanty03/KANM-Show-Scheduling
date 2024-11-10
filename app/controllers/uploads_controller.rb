class UploadsController < ApplicationController
  def handle_upload
    Rails.logger.info(params.inspect)
    if params[:upload].nil? || params[:upload][:csv_file].nil?
      redirect_to welcome_path, alert: "Please select a file to upload."
    else
      create(params[:upload][:csv_file])
    end
  end

  private


  def create(uploaded_file)
    # Validate that the uploaded file is a CSV
    if !valid_csv?(uploaded_file)
      redirect_to welcome_path, alert: "Invalid file type. Please choose a xlsx file to upload." and return
    elsif long_name?(uploaded_file)
      redirect_to welcome_path, alert: "File name is too long. Please rename the file and try again." and return
    elsif duplicate_name?(uploaded_file)
      redirect_to welcome_path, alert: "There is a file with the same name. Please rename the file and try again." and return
    end

    upload_path = Rails.env.test? ? Rails.root.join("tmp", "test_uploads") : Rails.root.join("public", "uploads")

    FileUtils.mkdir_p(upload_path) unless Dir.exist?(upload_path)

    File.open(File.join(upload_path, uploaded_file.original_filename), "wb") do |file|
      file.write(uploaded_file.read)
    end

    redirect_to welcome_path, notice: "File uploaded successfully."
  end

  def valid_csv?(file)
    file.present? && File.extname(file.original_filename) == ".xlsx"
  end

  def long_name?(file)
    File.basename(file.original_filename).length >= 60
  end

  def duplicate_name?(file)
    # Use a different directory in test environment to isolate real data
    upload_path = Rails.env.test? ? "#{Rails.root}/tmp/test_uploads" : "#{Rails.root}/public/uploads"
    File.exist?(Rails.root.join(upload_path, file.original_filename))
  end
end
