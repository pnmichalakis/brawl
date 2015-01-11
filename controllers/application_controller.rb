class ApplicationController < Sinatra::Base
	helpers Sinatra::FlashHelper
	require 'koala'
	require 'dotenv'
	require 'rack-flash'
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
	use Rack::Flash, :sweep => true

	after { ActiveRecord::Base.connection.close }

	get '/' do
		user_is_logged_in = false


		if session[:user]
			@session = session[:user]
			@users = User.all - [@session]
			@user_matches = User.find(@session['id']).matches.map do |match|
													match.opponent_id
												end
			@seen_users = User.find(@user_matches)
			@unseen_users = @users - @seen_users
			@opponent = @unseen_users.sample
			@unread = Message.where({recipient_id: @session["id"], unread: true})
			@unseen = Match.where({user_id: @session["id"], status: 2, seen: false})
			# @age = Time.now.year - @opponent["dob"][6..-1].to_i
			erb :index
		else
			redirect '/login'
		end
	end

	get '/login' do
		# prep the 'login with facebook link'
		@oauth    = Koala::Facebook::OAuth.new(ENV['APPID'], ENV['APPSECRET'], ENV['CALLBACKURL'])
		@auth_url = @oauth.url_for_oauth_code(:permissions => ["email", "user_photos", "user_birthday"])
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
				@user.gender = @person["gender"]
				@user.height = @user.name + " left this field blank!"
				@user.weight = @user.name + " left this field blank!"
				@user.location = @user.name + " left this field blank!"
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
		if params[:status] == "1"
			if Match.where("opponent_id = ? and user_id = ? and status = ?", user_id, opponent_id, 1) != []
				matched = Match.where("opponent_id = ? and user_id = ? and status = ?", user_id, opponent_id, 1)
				Match.update(matched.first.id, status: 2)
				# Match.where("opponent_id = ? and user_id = ? and status = ?", user_id, opponent_id, 1).update(status: 2)
				Match.create({user_id: user_id, opponent_id: opponent_id, status: 2, seen: false})
				flash[:notice] = "You have a new match!"
			else
				Match.create({user_id: user_id, opponent_id: opponent_id, status: status, seen: false})
			end
		else
			Match.create({user_id: user_id, opponent_id: opponent_id, status: status, seen: false})
		end
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
		@unread = Message.where({recipient_id: @user["id"], unread: true})
		if @user != @person
			redirect '/'
		end
		erb :'/users/show'
	end

	patch '/profiles/:id/vitals' do
		person = User.find(params[:id])
		height = person["height"]
		edit_height = params["edit_height"]
		weight = person["weight"]
		edit_weight = params["edit_weight"]
		location = person["location"]
		edit_location = params["edit_location"]
		bio = person["bio"]
		edit_bio = params['edit_bio']
		person.update({height: edit_height, weight: edit_weight, location: edit_location, bio: edit_bio})
		redirect'/'
	end

	get '/:id/matches' do
		@session = session[:user]
		@users = User.all
		# @matches = Match.all
		@matched = @session.matches.where({status: 2})
		@matched_user_ids = @matched.map do |match|
											match.opponent_id
										end
		@matched_users = User.find(@matched_user_ids)
		@unread = Message.where({recipient_id: @session["id"], unread: true})
		erb :matches
	end

	get '/matches/:id' do
		@session = session[:user]
		@match = Match.find(params[:id])
		@messages = Message.all
		@user_msg = @messages.where({sender_id: session[:user]['id'], recipient_id: @match['opponent_id']})
		@opp_msg = @messages.where({sender_id: @match['opponent_id'] , recipient_id: session[:user]['id']})
		@all_msg = @user_msg + @opp_msg
		@all_msg_sorted = @all_msg.sort_by{ |message| message.created_at }
		@unread = @opp_msg.where(unread: true)
		@unread.map do |message|
			message.update(unread: false)
		end
		erb :messages
	end

	post '/matches/:id/messages' do
		sender_id = session[:user]['id']
		@match = Match.find(params[:id])
		recipient_id = params['recipient_id']
		body = params['body']
		Message.create({sender_id: sender_id, recipient_id: recipient_id, body: body, unread: true})
		redirect '/matches/' + @match.id.to_s
	end

end


