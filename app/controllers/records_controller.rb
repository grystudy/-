class RecordsController < ApplicationController
	def index
		@records = Record.order(updated_at: :desc)
	end

	def destroy
		@record = Record.find(params[:id])
		@record.destroy
		redirect_to records_path, notice: "已撤销变更"
	end

	def push_diff
		revision = Revision.last
		@commit = true
		if revision
			data = Record.where(revision_id: revision.id,uploaded: false)
			if data.length >= 0				
				if params[:execute]
					if async_upload_records data
						new_revision = Revision.create({name: "after push diff"})
						new_revision.user = current_user
						new_revision.save!						
						redirect_to push_diff_records_path,notice: "所有数据上传成功!"
					else
						redirect_to push_diff_records_path,notice: "某些数据上传失败，请重新尝试!"
					end
					return									
				end
			end
			@records = data
			render 'index'
			return			
		else
			redirect_to records_path,notice: "无版本"
			return
		end
	end

	def push_all
		revision = Revision.last
		if revision
			relation = Record.select("max(revision_id) as last_version,oiltype_id,region_id").group("oiltype_id,region_id")
			data = []
			relation.each do |e|
				rec_ = Record.where(oiltype_id: e.oiltype_id,revision_id: e.last_version,region_id: e.region_id)
				if rec_.length == 1
					data << rec_.first
				else
					raise 'unknown'
				end
			end
			if data.length == 0
				message = "发布失败,无新数据!"
			else				
					if async_upload_records data
						new_revision = Revision.create({name: "after push all"})
						new_revision.user = current_user
						new_revision.save!
						message = "发布成功并且创建新版本。"
					else
						message = "上传数据失败。"
					end				
			end
		else
			message = "无版本"
		end

		redirect_to records_path,notice: message
	end

	def stash
		revision = Revision.last
		if revision
			data = Record.where(revision_id: revision.id)
			if data.length == 0
				message = "创建失败,无新数据!"
			else
				new_revision = Revision.create({name: "after stash"})
				new_revision.user = current_user
				new_revision.save!
				message = "成功"
			end
		else
			message = "无版本"
		end

		redirect_to records_path,notice: message
	end

	private		
	require 'net/http'

	@@base_uri = "http://staging.loopon.cn"
		# base_uri = "http://192.168.5.57:3001"
	
	def upload_record record_
		sub_url = "api/v1/chargeservice/oilprice/modifyOilPrice"
		params = "#{sub_url}?apikey=mxnavi&code=#{record_.region.code}&area=#{record_.region.name}&standard=#{record_.oiltype.standard.name}&number=#{record_.oiltype.name}&price=#{record_.value}&updatetime=#{record_.local_updated_at}"
		uri = @@base_uri +"/"+params
		begin
			res = Net::HTTP.get_response(URI(URI.encode(uri)))
			unless res
				logger.warn uri + '>>>' + 'failed'
				return false
			end
			res_code = eval(res.body)[:rspcode]
			logger.warn uri + '>>>' + res_code.to_s
			return res_code == 20000
		rescue Exception => e
			logger.warn uri + '>>>' + e.message
			return false 
		end
	end

	def async_upload_records records_
		res = true
		return res if !records_ || records_.length == 0
		raise 'not uniq' unless records_.size == records_.uniq{|item_|item_.id}.size
		::Rails.logger.warn(Time.now.localtime.to_s + '*******************************************************'+" count: #{records_.size}")
		max_thread_count = 3
		index = 0
		while index < records_.length
			break unless res
			left = records_.length - index
			min = left > max_thread_count ? max_thread_count : left
			arr = []
			min.times do |i|
				rec = records_[index]
				index = index + 1
   			arr[i] = Thread.new { Thread.current["rec"] = rec; upload_record rec}
			end
			arr.each do |t| 
				break unless res
				t = t.join(5);
				if t && t.value
					rec =	t["rec"]
					rec.uploaded = true
					rec.save!
				else
					res = false
				end
			end
		end
		return res
	end

	def sync_upload_records records_
		res = true
		return res if !records_ || records_.length == 0
		index = 0
		while index < records_.length
			rec = records_[index]
			index = index + 1
			succeed = upload_record rec
			if succeed
				rec.uploaded = true
				rec.save!
			else
				res = false
  		end			
  	end
		return res
	end
end
