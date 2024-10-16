class DownloadController < ApplicationController
    def download
      selected_csv_files = params[:selected_files]
      if selected_csv_files && selected_csv_files.any?
        zipfile_name = "archived_files.zip"

        # Remove existing zip file if it exists
        zipfile_path = Rails.root.join(zipfile_name)
        if File.exist?(zipfile_path)
            File.delete(zipfile_path)
        end

        Zip::File.open(zipfile_name, create: true) do |zipfile|
          selected_csv_files.each do |csv_file|
            csv_file_path = Rails.root.join("public", "uploads", csv_file)
            if File.exist?(csv_file_path)
              zipfile.add(csv_file, csv_file_path)
            end
          end
        end

        send_file zipfile_name, type: "application/zip", disposition: "attachment"
      else
        redirect_to welcome_path, alert: "No file selected for download."
      end
    end
end
