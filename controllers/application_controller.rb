class ApplicationController < Sinatra::Base
	helpers Sinatra::AuthenticationHelper
require 'koala'
require 'dotenv'
Dotenv.load
ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'fighting_database'
	})

set :views, File.expand_path('../../views',__FILE__)
set :public, File.expand_path('../../public',__FILE__)

enable :sessions, :method_override


get '/' do
	access_token = ENV['ACCESSTOKEN']
	@graph = Koala::Facebook::API.new(access_token)
	@person = @graph.get_object("me")
	binding.pry
	erb :index
end


end