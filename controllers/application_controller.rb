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
		user_is_logged_in = false

		if session[:user]
			# app code
			# swiping and stuff

			erb :index
		else
			redirect '/login'
		end
	end



	get '/login' do
		# prep the 'login with facebook link'
		@oauth    = Koala::Facebook::OAuth.new(ENV['APPID'], ENV['APPSECRET'], "http://localhost:9292/login")
		@auth_url = @oauth.url_for_oauth_code

		# authenticate user against facebook
		if params['code']
			@code = params['code']
			@access_token = @oauth.get_access_token(@code)
			@graph = Koala::Facebook::API.new(@access_token)
			@person = @graph.get_object("me")
			@photo = @graph.get_picture("me")

			# Check if  user exists in the database
			@user = User.find_by({fbid: @person["id"]})
			puts "\n"
			puts "\n"
			puts @person.inspect
			puts "\n"
			puts "\n"


			if @user == nil
				@user = User.new
 	 	 	  @user.name = @person["name"]
 	 		  @user.picture = @photo
  	    @user.email = @person["email"]
  	    @user.fbid = @person["id"]
  	    @user.save!
			end

			session[:user] = @user
			redirect '/'
		end

		erb :login
	end


	get '/logout' do
		session[:user] = nil
		redirect '/login'
	end
end


