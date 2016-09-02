class RegionsController < ApplicationController
	before_action :all_regions, :only => :index
	before_action :all_oiltypes, :only => :index   
	before_action :region, :only => [:show, :add_record_for]
	before_action :all_standards, :only => :show       

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

	def add_record_for
		message = "创建失败"
		o_type_id = params[:oiltype_id]
		revision = Revision.last
		if o_type_id && revision
			if @region.has_oiltype? o_type_id
				message = "已存在"
			else
			o_type = Oiltype.find o_type_id
			record = Record.new
			record.value = "6.00"
			record.user = current_user
			record.revision = revision
			record.oiltype = o_type
			record.region = @region
			message = "创建成功" if record.save		
			end	
		end
		redirect_to region_path(@region), notice: message
	end

	private

	def all_regions
		@regions = Region.all 
	end

	def all_oiltypes
		@oiltypes = Oiltype.all
	end

	def all_standards
		@standards = Standard.all
	end

	def region
		@region = Region.find(params[:id])
	end
end
