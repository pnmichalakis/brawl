require 'bundler'
Bundler.require(:default)
Dir.glob('./{helpers,models,controllers}/*.rb').each do |file|
	require file
	puts "required #{file}"
end

map('/matches'){ run MatchesController }
map('/users'){ run UsersController }
map('/sessions'){ run SessionsController }
map('/'){ run ApplicationController }