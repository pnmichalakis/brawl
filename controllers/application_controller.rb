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
set :public_folder, File.expand_path('../../public',__FILE__)

enable :logging, :dump_errors, :raise_errors, :show_exceptions
enable :sessions, :method_override

	get '/' do
		user_is_logged_in = false



		if session[:user]
			@session = session[:user];
			@users = User.all
			@previouslikes = @session.likes.map do |like|
				like.opponent_fb_id
			end
			@previousdislikes = @session.dislikes.map do |dislike|
				dislike.opponent_fb_id
			end
			@previous = @previousdislikes + @previouslikes
			binding.pry
			@opponent = @users.sample
			# app code
			# swiping and stuff
			#index on username database?
			erb :index
		else
			redirect '/login'
		end
	end

	get '/login' do
		# prep the 'login with facebook link'
		@oauth    = Koala::Facebook::OAuth.new(ENV['APPID'], ENV['APPSECRET'], "http://localhost:9292/login")
		@auth_url = @oauth.url_for_oauth_code(:permissions => "email", :permissions => "user_photos", :permissions => "user_birthday")

		# authenticate user against facebook
		if params['code']
			@code = params['code']
			@access_token = @oauth.get_access_token(@code)
			@graph = Koala::Facebook::API.new(@access_token)
			@person = @graph.get_object("me")
			@photo = @graph.get_picture("me", :type => "large")

			# Check if  user exists in the database
			@user = User.find_by({fbid: @person["id"]})



			if @user == nil
				@user = User.new
 	 	 	  @user.name = @person["name"]
 	 		  @user.picture = @photo
  	    @user.email = @person["email"]
  	    @user.fbid = @person["id"]
  	    @user.dob = @person["birthday"]
  	    @user.bio = @user.name + " hasn't said anything about him/herself, but is probably full of moxie!"
  	    @user.save!
			end

			session[:user] = @user
			redirect '/'
		end

		erb :login
	end

	post '/likes' do
		user_id = session["user"]["id"]
		opponent_fb_id = params['opponent_fb_id']
		Like.create({user_id: user_id, opponent_fb_id: opponent_fb_id})
		redirect '/'
	end

	post '/dislikes' do
		user_id = session["user"]["id"]
		opponent_fb_id = params['opponent_fb_id']
		Dislike.create({user_id: user_id, opponent_fb_id: opponent_fb_id})
		redirect '/'
	end

	get '/logout' do
		session[:user] = nil
		redirect '/login'
	end

  get '/profiles/:id' do
    @user = session[:user]
    @users = User.all
    @person = User.find(params[:id])
    erb :'/users/show'
  end
  patch '/profiles/:id/bio' do
 		person = User.find(params[:id])
 		bio = person["bio"]
  	edit_bio = params['edit_bio']
  	person.update({bio: edit_bio})
  	redirect '/'
	end

end


