class UsersController < ApplicationController
  # GET /users/new
  get '/new' do
    # render form for creation of new user
    erb :'users/new'
  end
  post '/' do
  	user = User.new(params[:user])
    user.name = @person["name"]
  	user.picture = @photo
    user.dob = @person["birthday"]
  	user.save!
	end

end