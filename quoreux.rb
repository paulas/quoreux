# encoding: utf-8

require 'zlib'

class Quoreux < Sinatra::Base
  set :app_file => __FILE__

  register Sinatra::ConfigFile
  config_file File.join(root, 'config', 'config.yml')

  set :layout => 'layout'

  get '/' do
    erubis :index
  end

  get '/:crc32' do
    @crc32 = params[:crc32]
    erubis :show
  end

  post '/qr' do
    crc32 = Zlib.crc32(params[:data])

    image_path = File.join(settings.public, 'images',
      "#{crc32}.png")

    unless File.exist? image_path
      qr = RQRCode::QRCode.new(params[:data])

      size = qr.module_count * settings.cell_width
      image = GD2::Image::IndexedColor.new(size, size)

      bright = GD2::Color.new_from_rgba(settings.cell_bright)
      image.palette << bright

      dark = GD2::Color.new_from_rgba(settings.cell_dark)
      image.palette << dark

      image.draw do |canvas|
        qr.modules.each_index do |y|
          qr.modules.each_index do |x|
            canvas.color = qr.is_dark(y, x) ? dark : bright
            canvas.rectangle(x * settings.cell_width,
                             y * settings.cell_width,
                       (x + 1) * settings.cell_width,
                       (y + 1) * settings.cell_width, true)
          end
        end
        image.export image_path
      end
    end

    redirect "/#{crc32}"
  end
end
