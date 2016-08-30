class RegionsController < ApplicationController
	def index
		@regions = Region.all 
		# records = Record.all
		# records.each do |variable|
		# 	variable.user = current_user if variable.user.nil? 
		# 	variable.save!
		# end
	end
end
