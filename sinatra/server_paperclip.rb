#!/usr/bin/ruby -rrubygems
# (from http://gist.github.com/291877 )
require 'sinatra'
require 'dm-core'
require 'dm-paperclip'
require 'haml'
require 'fileutils'

APP_ROOT = File.expand_path(File.dirname(__FILE__))

DataMapper::setup(:default, "sqlite3://#{APP_ROOT}/db.sqlite3")

class Resource
  include DataMapper::Resource
  include Paperclip::Resource

  property :id,     Serial

  has_attached_file :file,
                    :url => "/:attachment/:id/:style/:basename.:extension",
                    :path => "#{APP_ROOT}/public/:attachment/:id/:style/:basename.:extension"
end

Resource.auto_migrate!

def make_paperclip_mash(file_hash)
  mash = Mash.new
  mash['tempfile'] = file_hash[:tempfile]
  mash['filename'] = file_hash[:filename]
  mash['content_type'] = file_hash[:type]
  mash['size'] = file_hash[:tempfile].size
  mash
end

post '/upload' do
  halt 409, "File seems to be emtpy" unless params[:file][:tempfile].size > 0
  @resource = Resource.new(:file => make_paperclip_mash(params[:file]))
  halt 409, "There were some errors processing your request...\n#{resource.errors.inspect}" unless @resource.save

  haml :upload
end

get '/' do
  haml :index
end

__END__
@@ index
%form{:action => '/upload', :enctype => 'multipart/form-data', :method => 'POST'}
  %input{:type => 'file', :name => 'file'}
  %input{:type => 'submit'}

@@ upload
%p= "Congrats! This is your #{@resource.file.name} uploaded file!"
%img{:src => @resource.file.url }

