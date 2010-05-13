#!/usr/local/bin/ruby -rrubygems
require 'sinatra'
require 'pathname'
require 'zipruby'
require 'helpers'

require 'RMagick'

IWORK_EXTENSIONS = %w(pages numbers key)
EXTENSIONS = IWORK_EXTENSIONS + %w(pdf png jpg)
ASSETS_DIR = '../docs/example-assets'
#ASSETS = "#{ASSETS_DIR}/*.{#{EXTENSIONS.join(',')}}"
ASSETS = "#{ASSETS_DIR}/*"


get '/:asset.png' do
  asset = params[:asset]
  content_type 'image/png'
  path = Pathname.new(ASSETS_DIR).join asset
#  if IWORK_EXTENSIONS.include? path.extname[1..-1]
#    path.directory? ? path.join('QuickLook/Thumbnail.jpg').open.read :
#      Zip::Archive.open(path.realpath.to_s) { |z|
#        z.fopen('QuickLook/Thumbnail.jpg').read
#      }
#  else
    img = Magick::Image.read(path)[0]
    img.format = 'png'
    img.to_blob
#  end
end

get '/favicon.ico' do
end

get '/:asset' do
  haml :_asset , :locals => { :asset => params[:asset] }
end

get '/' do
  haml :assets, :locals => { :assets => Dir[ASSETS].collect { |f| Pathname.new f } }
end

__END__


@@ assets
%h1 Assets
- assets.each do |asset|
  %div.asset= haml :_asset, :locals => { :asset => asset }


@@ _asset
%div.thumbnail(style="background-image: url(/#{asset.basename}.png);")
= asset.basename
(
%b.extname= asset.extname[1..-1]
)


@@ layout
%html
  %head
    %title Librarian
    %link{:rel => 'stylesheet', :type => 'text/css', :href => '/css/main.css', :media => 'screen projection'}
  %body
    = yield
