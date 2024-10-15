class UploadsController < ApplicationController
  def new
    @upload = Upload.new
  end

  def create
    Rails.logger.info(params.inspect)
    uploaded_file = params[:upload][:csv_file]

      upload_path = Rails.env.test? ? "#{Rails.root}/tmp/test_uploads" : "#{Rails.root}/public/uploads"
      
      FileUtils.mkdir_p(upload_path) unless Dir.exist?(upload_path)

      File.open(File.join(upload_path, uploaded_file.original_filename), 'wb') do |file|
        file.write(uploaded_file.read)

      end

      redirect_to welcome_path, notice: 'File uploaded successfully.'

  end

end
