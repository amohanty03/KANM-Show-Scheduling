class WelcomeController < ApplicationController
  def index
    # Use a different directory in test environment to isolate real data
    upload_path = Rails.env.test? ? "#{Rails.root}/tmp/test_uploads" : "#{Rails.root}/public/uploads"

    # Check for CSV and XLSX files in the specified directory
    @csv_files = Dir.glob("#{upload_path}/*.{csv,xlsx}")
  end

  def delete_csv_files
    # Use a different directory in test environment to isolate real data
    upload_path = Rails.env.test? ? "#{Rails.root}/tmp/test_uploads" : "#{Rails.root}/public/uploads"

    if params[:selected_files].present?
      params[:selected_files].each do |file_name|
        file_path = Rails.root.join(upload_path, file_name)


        if File.exist?(file_path)
          File.delete(file_path)
        else
          logger.warn("#{file_name} does not exist.")
        end
      end
      flash[:notice] = "Selected files have been deleted."
    end
    redirect_to welcome_path
  end
end
