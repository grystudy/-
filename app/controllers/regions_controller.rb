class RegionsController < ApplicationController
	before_filter :all_regions, :except => :show
	before_filter :all_oiltypes, :except => :show    

	def index
		# records = Record.all
		# records.each do |variable|
		# 	variable.user = current_user if variable.user.nil? 
		# 	variable.save!
		# end
	end

	def all_regions
		@regions = Region.all 
	end

	def all_oiltypes
		@oiltypes = Oiltype.all
	end
end
