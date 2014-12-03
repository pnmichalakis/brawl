class ApplicationController < Sinatra::Base
	helpers Sinatra::AuthenticationHelper
ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'fighting_database'
	})

set :views, File.expand_path('../../views',__FILE__)
set :public, File.expand_path('../../public',__FILE__)


enable :sessions, :method_override


get '/' do
	erb :index
end


end