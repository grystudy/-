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
	end
end
