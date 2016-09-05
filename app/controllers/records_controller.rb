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
		if revision
			data = Record.where(revision_id: revision.id)
			if data.length == 0
				message = "发布失败,无新数据!"
			else
				new_revision = Revision.create({name: "after push diff"})
				new_revision.user = current_user
				new_revision.save!
				message = "成功"
			end
		else
			message = "无版本"
		end

		redirect_to records_path,notice: message
	end

	def push_all
		revision = Revision.last
		if revision
			relation = Record.select("max(revision_id) as last_version,oiltype_id").group("oiltype_id")
			data = []
			relation.each do |variable|
				rec_ = Record.where(oiltype_id: variable.oiltype_id,revision_id: variable.last_version)
				if rec_.length == 1
					data << rec_.first
				end
			end
			if data.length == 0
				message = "发布失败,无新数据!"
			else
				data = Record.where(revision_id: revision.id)
				if data.length == 0
					message = "发布成功但不需要创建新版本。"
				else
					new_revision = Revision.create({name: "after push all"})
					new_revision.user = current_user
					new_revision.save!
					message = "发布成功并且创建新版本。"
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
end
