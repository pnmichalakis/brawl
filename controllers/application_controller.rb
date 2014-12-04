class ApplicationController < Sinatra::Base
	helpers Sinatra::AuthenticationHelper
ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'fighting_database'
	})

set :views, File.expand_path('../../views',__FILE__)
set :public, File.expand_path('../../public',__FILE__)
require 'koala'

enable :sessions, :method_override


get '/' do
	@graph = Koala::Facebook::API.new(ENV['ACCESSTOKEN'])
	@person = @graph.get_object("me")
	binding.pry
	erb :index
end


end