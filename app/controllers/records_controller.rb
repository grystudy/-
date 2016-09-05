class RecordsController < ApplicationController
	def index
		@records = Record.order(updated_at: :desc)
	end

	def destroy
		@record = Record.find(params[:id])
		@record.destroy
		redirect_to records_path, notice: "已撤销变更"
	end
end
