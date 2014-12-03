class UsersController < ApplicationController
  # GET /users/new
  get '/new' do
    # render form for creation of new user
    erb :'users/new'
  end
  post '/' do
  	user = User.new(params[:user])
  	user.password = params[:password]
  	user.save!
  redirect '/sessions/new'
	end

end