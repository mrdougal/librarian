#!/usr/local/bin/ruby -rrubygems
require 'sinatra'
require 'pathname'
require 'zipruby'
require 'helpers'

ASSETS_DIR = '../docs/example-assets/iWork docs'
ASSETS = "#{ASSETS_DIR}/*.{pages,numbers,key}"

get '/:asset.png' do
  asset = params[:asset]
  content_type 'image/png'
  path = Pathname.new(ASSETS_DIR).join asset
  Zip::Archive.open(path.realpath.to_s) { |z|
    f = z.fopen('QuickLook/Thumbnail.jpg')
    data = f.read
  }
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
%img.thumbnail(src="/#{asset.basename}.png" alt="#{asset.basename}")
= asset.basename


@@ layout
%html
  %head
    %title Librarian
    %link{:rel => 'stylesheet', :type => 'text/css', :href => '/css/main.css', :media => 'screen projection'}
  %body
    = yield
