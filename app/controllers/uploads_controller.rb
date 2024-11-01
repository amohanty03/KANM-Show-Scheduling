class UploadsController < ApplicationController
  def create
    Rails.logger.info(params.inspect)
    uploaded_file = params[:upload][:csv_file]

    # Validate that the uploaded file is a CSV
    unless valid_csv?(uploaded_file)
      redirect_to welcome_path, alert: "Invalid file type. Please choose a xlsx file to upload." and return
    end

    upload_path = Rails.env.test? ? Rails.root.join("tmp", "test_uploads") : Rails.root.join("public", "uploads")

    FileUtils.mkdir_p(upload_path) unless Dir.exist?(upload_path)

    File.open(File.join(upload_path, uploaded_file.original_filename), "wb") do |file|
      file.write(uploaded_file.read)
    end

    redirect_to welcome_path, alert: "File uploaded successfully."
  end

  private

  def valid_csv?(file)
    file.present? && File.extname(file.original_filename) == ".xlsx"
  end
end
