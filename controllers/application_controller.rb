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
	enable :method_override
	use Rack::Session::Pool

	get '/' do
		user_is_logged_in = false


		if session[:user]
			@session = session[:user]
			@users = User.all
			@removed = []
			@potential = []
			@non_user_users = @users - [@session]
			# @previouslikes = @session.likes.map do |like|
			# 	like.opponent_id
			# end
			# @previousdislikes = @session.dislikes.map do |dislike|
			# 	dislike.opponent_id
			# end
			# @previous = @previousdislikes + @previouslikes
			# @non_user_users.each do |x|
   #      exclude = false
   #      @previous.each do |y|
   #        if x.id == y
   #          exclude = true
   #          @removed << x
   #        end
   #      end
   #      if !exclude
   #        @potential << x
   #      end
   #    end
			# @opponent = @potential.sample
			@opponent = @non_user_users.sample
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
		@auth_url = @oauth.url_for_oauth_code(:permissions => ["email", "user_photos", "user_birthday"])
		#:permissions => "user_photos",
		#:permissions => "user_birthday")

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

	post '/matches' do
		user_id = session["user"]["id"]
		opponent_id = params["opponent_id"]
		status = params[:status]
		binding.pry
		if params[:status] == 1
			Match.where("opponent_id IS NOT NULL")
			Match.create({user_id: user_id, opponent_id: opponent_id, status: status})
		# create a relationship record with a status of 0
		# check if the other guys relationship status = 1
		#   if he does, set the original relationship status to 2
		#     create new relationship status for current user with 2
		else
			Match.create({user_id: user_id, opponent_id: opponent_id, status: status})

		end
		#   if he doesnt
		#     create a relationship with a status of 1
		redirect '/'
	end

	# post '/likes' do
	# 	user_id = session["user"]["id"]
	# 	opponent_id = params['opponent_id']
	# 	Like.create({user_id: user_id, opponent_id: opponent_id})
	# 	opponent = User.find(opponent_id)
	# 	opplikes = opponent.likes.map do |like|
	# 							like.opponent_id
	# 						end
	# 						binding.pry
	# 	if opplikes.include? session[:user].id = true
	# 		Match.create({user_id: user_id, opponent_id: opponent.id})
	# 		Match.create({user_id: opponent.id, opponent_id: user_id})
	# 	end
	# 	redirect '/'
	# end

	# post '/dislikes' do
	# 	user_id = session["user"]["id"]
	# 	opponent_id = params['opponent_id']
	# 	Dislike.create({user_id: user_id, opponent_id: opponent_id})
	# 	redirect '/'
	# end

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

	get '/:id/matches' do
		@session = session[:user]
		@users = User.all
		@matches = Match.all
		binding.pry
		erb :matches
	end

end


