require "zip"

class DownloadController < ApplicationController
    def download
      selected_csv_files = params[:selected_files]
      if selected_csv_files && selected_csv_files.any?
        zipfile_name = "archived_files.zip"

        # Remove the existing zip file if needed...
        # this avoids errors from a "file already existing"
        # if you download multiple times
        zipfile_path = Rails.env.test? ? Rails.root.join("tmp", "test_downloads", zipfile_name) : Rails.root.join("public", "downloads", zipfile_name)

        if File.exist?(zipfile_path)
            File.delete(zipfile_path)
        end

        upload_path = Rails.env.test? ? Rails.root.join("tmp", "test_uploads") : Rails.root.join("public", "uploads")

        Zip::File.open(zipfile_path, create: true) do |zipfile|
          selected_csv_files.each do |csv_file|
            csv_path = Rails.root.join(upload_path, csv_file)
            # check file exists here?
            zipfile.add(csv_file, csv_path)
          end
        end

        send_file zipfile_path
      else
        redirect_to welcome_path, alert: "No file selected for download."
      end
    end
end
