require 'bundler'
Bundler.require(:default)
Dir.glob('./{helpers,models,controllers}/*.rb').each do |file|
	require file
	puts "required #{file}"
end
require './helpers/link_helper'