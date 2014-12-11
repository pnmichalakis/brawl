class User < ActiveRecord::Base
	has_many(:messages)
	has_many(:likes)
	has_many(:dislikes)
end
