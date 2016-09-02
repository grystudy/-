class RegionsController < ApplicationController
	before_action :all_regions, :only => :index
	before_action :all_oiltypes, :only => :index   
	before_action :region, :only => [:show, :add_record_for,:update]
	before_action :all_standards, :only => :show       

	def show
		@hash_records = @region.hash_records
	end

	def update
		revision = get_or_create_revision
		@region.records.each do |record|
			value = params[record.oiltype.id.to_s]
			next unless value
			value = value.to_f
			next if value == record.value
			if record.revision && record.revision.id == revision.id
				record.value = value
				record.user = current_user
				record.save!
			else
				new_rec = Record.new
				new_rec.value = value
				new_rec.user = current_user
				new_rec.revision = revision
				new_rec.oiltype = record.oiltype
				new_rec.region = @region
				new_rec.save!
			end
		end
		redirect_to root_path, notice: "已更新"
	end

	def add_record_for
		message = "创建失败"
		o_type_id = params[:oiltype_id]
		revision = get_or_create_revision
		if o_type_id
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

	def get_or_create_revision
		revision = Revision.last
		if !revision
			revision = Revision.new 
			revision.name = "initialize"
			revision.user = current_user
			revision.save!
		end
		revision
	end
end