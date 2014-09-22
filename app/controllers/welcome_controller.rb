class WelcomeController < ApplicationController
  require 'json'

  def index
  end

  def export_text
    view_source = params[:source]
    exported_text = process_text(view_source)
    if exported_text.present?
      send_data exported_text, :filename => 'ohlife_export.json'
    else
      flash[:error] = "No entries to export"
      redirect_to :back
    end
  end

  private

    def process_text(view_source)
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

        text = entry.split('<div class="text">')
        if text[1].present?
          text = text[1].split('</div>')[0].gsub("\r\n ","").strip
        end        

        @parsed << {:day => day, :image => image_url}
        if day.present? && day != "\r\n<!DOCTYPE "
          if image_url.present?
            ext = File.extname(image_url)
            image_filename = "#{day}#{ext}"
          end

          files_to_zip << 
            { 
              :day_code => "#{day.gsub("day_","")}", 
              :date => Date.parse(day.gsub("day_","").to_date().to_s).strftime("%B %d, %Y"),
              :image_filename => "#{image_filename}",
              :image_url => image_url,
              :text => text
            }

        end
      end

      JSON.pretty_generate(files_to_zip.compact)
    end

end
