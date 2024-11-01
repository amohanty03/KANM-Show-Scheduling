require "zip"

class DownloadController < ApplicationController
  def download
    selected_csv_files = params[:selected_files]
    
    if selected_csv_files && selected_csv_files.any?
      zipfile_name = "archived_files.zip"
      zipfile_path = generate_zipfile_path(zipfile_name)
  
      remove_existing_zipfile(zipfile_path)
  
      upload_path = determine_upload_path
      create_zipfile(zipfile_path, selected_csv_files, upload_path)
  
      send_file zipfile_path
    else
      redirect_to welcome_path, alert: "No file selected for download."
    end
  end
  
  private
  
  def generate_zipfile_path(zipfile_name)
    Rails.env.test? ? Rails.root.join("tmp", "test_downloads", zipfile_name) : Rails.root.join("public", "downloads", zipfile_name)
  end
  
  def remove_existing_zipfile(zipfile_path)
    File.delete(zipfile_path) if File.exist?(zipfile_path)
  end
  
  def determine_upload_path
    Rails.env.test? ? Rails.root.join("tmp", "test_uploads") : Rails.root.join("public", "uploads")
  end
  
  def create_zipfile(zipfile_path, selected_csv_files, upload_path)
    Zip::File.open(zipfile_path, create: true) do |zipfile|
      selected_csv_files.each do |csv_file|
        csv_path = Rails.root.join(upload_path, csv_file)
        zipfile.add(csv_file, csv_path) if File.exist?(csv_path)  # Check if file exists before adding
      end
    end
  end  
end
