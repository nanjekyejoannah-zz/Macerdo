require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-paperclip'
require 'haml'
require 'fileutils'
require 'dm-migrations/adapters/dm-sqlite-adapter'
require 'data_mapper'
require 'dm-migrations'
 
APP_ROOT = File.expand_path(File.dirname(__FILE__))
 
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/macerdo.db")

class DevApp
	include DataMapper::Resource
	include Paperclip::Resource
	 
	property :id, Serial
	property :name, String
	property :appDescription, String
	property :priceInDollars, String 
	property :priceInUGX, String
	property :created_at, DateTime
	 
	 has_attached_file :file,
					:url => "/:attachment/:id/:style/:basename.:extension",
					:path => "#{APP_ROOT}/public/:attachment/:id/:style/:basename.:extension"

	DataMapper.finalize.auto_upgrade! 
end

class QAApp
	include DataMapper::Resource
	include Paperclip::Resource
	 
	property :id, Serial
	property :name, String
	property :appDescription, String
	property :priceInDollars, String 
	property :priceInUGX, String
	property :created_at, DateTime
	 
	 has_attached_file :file,
					:url => "/:attachment/:id/:style/:basename.:extension",
					:path => "#{APP_ROOT}/public/:attachment/:id/:style/:basename.:extension"

	DataMapper.finalize.auto_upgrade! 
end



 
def make_paperclip_mash(file_hash)
	mash = Mash.new
	mash['tempfile'] = file_hash[:tempfile]
	mash['filename'] = file_hash[:filename]
	mash['content_type'] = file_hash[:type]
	mash['size'] = file_hash[:tempfile].size
	mash
end
 
get '/' do 
	erb :index
end

get '/upload' do
	erb :dev_index
end

post '/upload' do
	@resource = DevApp.create(:name => params[:name], :appDescription => params[:appDescription], :priceInDollars => params[:priceInDollars], :priceInUGX => params[:priceInUGX], :created_at => DateTime.now , :file => params[:file])
	if @resource.save
		# File.open('uploads/' + params[:file[:filename], "w") do |f|
  #   	f.write(params[:file][:tempfile].read)
  # end
		redirect '/'
	else	
	end
end

get '/apps' do
	@resource = DevApp.all
  	erb :dev_apps
end

get '/market' do
	@apps = QAApp.all
	erb :market
end

get '/QAHome' do

	@resource = DevApp.all
	erb :QA_home
end
get '/market1' do
	@apps = QAApp.all
	erb :market1
end
get '/market2' do
	@apps = QAApp.all
	erb :market2
end


get '/VerifyApps' do
	
  	erb :verify_apps
end

post '/VerifyApps' do
	@resource = QAApp.create(:name => params[:name], :appDescription => params[:appDescription], :priceInDollars => params[:priceInDollars], :priceInUGX => params[:priceInUGX], :created_at => DateTime.now , :file => params[:file])
	if @resource.save
		# File.open('uploads/' + params[:file[:filename], "w") do |f|
  #   	f.write(params[:file][:tempfile].read)
  # end
		redirect '/QAHome'
	else
		redirect '/QAHome'

	end
end
