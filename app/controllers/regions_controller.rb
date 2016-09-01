class RegionsController < ApplicationController
	before_action :all_regions, :except => :show
	before_action :all_oiltypes, :except => :show   
	before_action :region, :only => :show    

	def index
		# records = Record.all
		# records.each do |variable|
		# 	variable.user = current_user if variable.user.nil? 
		# 	variable.save!
		# end
	end

	def show
		@hash_records = @region.hash_records
	end

	def all_regions
		@regions = Region.all 
	end

	def all_oiltypes
		@oiltypes = Oiltype.all
	end

	def region
		@region = Region.find(params[:id])
	end
end
