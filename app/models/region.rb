class Region < ApplicationRecord
	has_many :records
	has_many :oiltypes,through: :records

	def hash_records
		hash = records.group_by do |variable|
			variable.oiltype.standard.name
		end
		hash.each do |variable|
			hash[variable.first] = variable.last.group_by do |i|
				i.oiltype.name
			end
		end
		hash.each do |hash_|
			hash_.last.each do |variable|				
				revisions_record = Record.sort_by_version_desc variable.last
				first = revisions_record.first
				second = revisions_record.length == 1 ? nil : revisions_record[1]
				hash_.last[variable.first] = [first,second]
			end
		end
		hash
	end

	def has_oiltype? oiltype_id_
		oiltypes.exists?(id: oiltype_id_)
	end

	def get_value oiltype
		o_id = oiltype.id
		return 0 unless has_oiltype? o_id
		items = Record.sort_by_version_desc(records.where(oiltype: oiltype).all)
		return items.length >0 ? items.first.value : 0;
	end
end
