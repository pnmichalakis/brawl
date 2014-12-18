class MatchesController < ApplicationController
	get '/:id' do
		@match = Match.find(params[:id])
		erb :messages
	end

end