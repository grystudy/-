class Record < ApplicationRecord
  belongs_to :region
  belongs_to :oiltype
  belongs_to :user
  belongs_to :revision

  def local_updated_at
  	updated_at.localtime.strftime("%Y/%m/%d %H:%M:%S")
  end

  class << self
		def sort_by_version_desc array
			res = array.sort do |a,b| 
				bR=b.revision
				aR = a.revision
				b_id = bR ? bR.id : 0
				a_id = aR ? aR.id : 0
				b_id<=>a_id
			end
			return res
		end

		def get_all
			data = []
			relation = Record.select("max(revision_id) as last_version,oiltype_id,region_id").group("oiltype_id","region_id")
			relation.each do |e|
				rec_ = Record.where(oiltype_id: e.oiltype_id,revision_id: e.last_version,region_id: e.region_id)
				data << rec_.first if rec_.length > 0
				if rec_.length == 1
				else
					raise 'unknown' if false
				end
			end
			data
		end
	end
end
