class SessionsController < ApplicationController
	get '/new' do
		erb :'sessions/new'
	end
	post '/' do
  	redirect '/' unless @user = User.find_by({email: params[:user]})
	end
	get '/destroy' do
	  session = nil
  	redirect '/'
	end
end