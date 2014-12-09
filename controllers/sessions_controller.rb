class SessionsController < ApplicationController
	get '/new' do
		erb :'sessions/new'
	end

end