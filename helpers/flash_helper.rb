module Sinatra
	module FlashHelper
		def flash_types
			[:notice]
		end
	end
	helpers FlashHelper
end