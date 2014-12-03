require 'bundler'
Bundler.require


ActiveRecord::Base.establish_connection({
	adapter: 'postgresql',
	database: 'fighting_database'
})

get '/' do
	erb :index
end



# @person = @graph.get_object("me")
# @picture = @graph.get_picture("me")
