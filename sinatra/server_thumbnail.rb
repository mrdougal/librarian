#!/usr/local/bin/ruby -rrubygems
require 'sinatra'
require 'pathname'
require 'zipruby'
require 'helpers'

# Ubuntu currently has conflicting versions for libimagemagick and rmagick
# This installation of RMagick was configured with ImageMagick 6.5.7 but ImageMagick 6.5.8-3 is in use
RMAGICK_BYPASS_VERSION_TEST = true
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
  img = Magick::Image.read("#{path.extname[1..-1]}:#{path}").first
  img.format = 'png'
  img.change_geometry!('130x140') { |cols, rows, i| i.resize!(cols, rows) }
  img.to_blob
end

get '/favicon.ico' do
end

get '/:asset' do
  haml :_asset , :locals => { :asset => params[:asset] }
end

get '/' do
  haml :assets, :locals => { :assets => Dir[ASSETS].collect { |f| Pathname.new f }.collect { |f| f unless f.directory? }.compact.sort }
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
