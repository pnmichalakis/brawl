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

enable :logging, :dump_errors, :raise_errors, :show_exceptions
enable :sessions, :method_override

	get '/' do
		@oauth    = Koala::Facebook::OAuth.new(ENV['APPID'], ENV['APPSECRET'], "http://localhost:9292/")
		@auth_url = @oauth.url_for_oauth_code

		if params['code']
			@code = params['code']
			@access_token = @oauth.get_access_token(@code)
			@graph = Koala::Facebook::API.new(@access_token)
			@person = @graph.get_object("me")
			@photo = @graph.get_picture("me")
			@user = User.new
   	  @user.name = @person["name"]
  	  @user.picture = @photo
      @user.email = @person["email"]
      @user.fbid = @person["id"]
  	  @user.save!
			# Create a user in the DB based on facebook credentials

			# Create session

		end



		erb :index
		# binding.pry
	end

	get '/logout' do
		# destroy session
		redirect '/'
	end

end


