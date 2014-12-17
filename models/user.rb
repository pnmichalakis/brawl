class User < ActiveRecord::Base
	# has_many(:likes)
	# has_many(:dislikes)
	# has_many(:matches)
	# has_many(:opponents, :through => :matches)
	scope :seen_users, -> { joins(:matches).where('status != nil', true) }
	scope :do_not_want_to_fight, -> { joins(:matches).where('status = 0', true) }
	scope :want_to_fight, -> { joins(:matches).where('status, = 1', true) }
	scope :matched, -> { joins(:matches).where('status = 2', true) }
	has_many(:matches)
	has_many(:messages)
	def seen_users
		self.matches.where(status: !nil)
	end
	# has_and_belongs_to_many(:seen_users,   :class_name => 'User')
	# has_and_belongs_to_many(:user,	      :class_name => 'User')
	# has_and_belongs_to_many(:opponent,	  :class_name => 'User')
	# has_and_belongs_to_many(:matches,  		:class_name => 'User')
	# belongs_to(:user)
	# belongs_to(:opponent, :class_name => 'User')
end