class DownloadZipController < ApplicationController

  def show
    @parsed = []
    view_source = params[:source]
    download_manifest = process_source(view_source)
    zip_up(download_manifest)
  end

  private

    def process_source(view_source)
      @parsed = []
      files_to_zip = []

      parse_data = view_source.split('<div class="entry ')
      parse_data.each do |entry|
        day = entry[0,12]

        images = entry.split('<div class="picinside')
        if images[1].present?
          images = images[1].split('<a href="')
          image_url = images[1].split('">')[0]
          if image_url[0,4] != "http"
            image_url = "http://ohlife.com" + image_url
          end
        else
          image_url = nil
        end

        @parsed << {:day => day, :image => image_url}
        if image_url.present? && day.present?
          ext = File.extname(image_url)
          files_to_zip << { :path => "#{day}#{ext}", :url => "#{URI.encode(image_url)}" }
        end
      end

      { name: "ohlife_export", files: files_to_zip.compact }      
    end

    def zip_up(download_manifest)
      begin
        if download_manifest[:files].length > 0
          begin
            response = HTTParty.post "http://#{ENV['DOWNLOADER_URL']}/downloads",
              headers: { 'Content-Type' => 'application/json' },
              basic_auth: {
                username: ENV['DOWNLOADER_ID'],
                password: ENV['DOWNLOADER_SECRET']
              },
              body: download_manifest.to_json
            @files_count = download_manifest[:files].length
            flash.now[:info] = "Downloading now..."
            redirect_to response['url']
          rescue
            flash[:error] = "Could not download ZIP file"
            redirect_to :back
          end
        else
          flash[:error] = "No attachments to download"
          redirect_to :back
        end
      rescue ActionController::RedirectBackError
        redirect_to root_path
      end
    end          

end