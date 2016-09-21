# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
all_regions = '地区Code	地区	89号汽油	90号汽油	92号汽油	93号汽油	95号汽油	97号汽油	0号柴油
110000	北京	5.51 	5.51 	5.89 	5.89 	6.27 	6.27 	5.50 
120000	天津	5.45 	5.45 	5.87 	5.87 	6.21 	6.21 	5.46 
130000	河北	5.45 	5.45 	5.87 	5.87 	6.21 	6.21 	5.46 
140000	山西	6.48 	6.48 	5.72 	5.72 	6.17 	6.17 	5.37 
150000	内蒙古	6.79 	6.79 	7.09 	7.09 	7.60 	7.60 	7.02 
210000	辽宁	5.48 	5.48 	5.86 	5.86 	6.25 	6.25 	5.39 
220000	吉林	5.17 	5.17 	5.54 	5.54 	6.02 	6.02 	5.12 
230000	黑龙江	6.00 	6.00 	5.55 	5.55 	5.97 	5.97 	5.02 
310000	上海	5.46 	5.46 	5.85 	5.85 	6.23 	6.23 	5.45 
320000	江苏	5.50 	5.50 	5.87 	5.87 	6.24 	6.24 	5.44 
330000	浙江	5.44 	5.44 	5.87 	5.87 	6.24 	6.24 	5.46 
340000	安徽	5.36 	5.36 	5.73 	5.73 	6.16 	6.16 	5.36 
350000	福建	5.46 	5.46 	5.87 	5.87 	6.26 	6.26 	5.47 
360000	江西	5.32 	5.32 	5.72 	5.72 	6.14 	6.14 	5.37 
370000	山东	5.45 	5.45 	5.87 	5.87 	6.29 	6.29 	5.46 
410000	河南	5.38 	5.38 	5.70 	5.70 	6.02 	6.02 	5.36 
420000	湖北	5.40 	5.40 	5.70 	5.70 	6.15 	6.15 	5.40 
430000	湖南	5.36 	5.36 	5.72 	5.72 	6.08 	6.08 	5.39 
440000	广东	5.49 	5.49 	5.91 	5.91 	6.40 	6.40 	5.48 
450000	广西	5.41 	5.41 	5.81 	5.81 	6.27 	6.27 	5.39 
460000	海南	6.48 	6.48 	7.00 	7.00 	7.42 	7.42 	5.56 
500000	重庆	5.51 	5.51 	5.83 	5.83 	6.16 	6.16 	5.42 
510000	四川	5.44 	5.44 	5.80 	5.80 	6.25 	6.25 	5.44 
520000	贵州	6.05 	6.05 	6.02 	6.02 	6.36 	6.36 	5.58 
530000	云南	5.43 	5.43 	5.89 	5.89 	6.33 	6.33 	5.42 
540000	西藏	6.22 	6.22 	6.59 	6.59 	6.96 	6.96 	5.85 
610000	陕西	5.46 	5.46 	5.79 	5.79 	6.12 	6.12 	5.38 
620000	甘肃	5.30 	5.30 	5.65 	5.65 	6.04 	6.04 	5.25 
640000	宁夏	5.35 	5.35 	5.67 	5.67 	5.99 	5.99 	5.24 
630000	青海	5.35 	5.35 	5.70 	5.70 	6.11 	6.11 	5.28 
650000	新疆	5.91 	5.91 	5.81 	5.81 	6.25 	6.25 	5.42'

array = all_regions.split "\n"
headers = array.shift.split "\t"
# oiltypes = []
# (2...headers.length).each_with_index do |variable_,index_|
# 	 oiltypes << Oiltype.create({code: index_+1, name: headers[variable_]})
# end

# admin = User.create({name: "admin",email: "admin@meixing.com",encrypted_password: "admin123",sign_in_count: 1})
version = Revision.create({name: "init database"})
# version.user = admin

array.each do |variable|
	sub_array = variable.split "\t"
	region = Region.create({name: sub_array[1], code: sub_array[0].to_i})
	# (2...sub_array.length).each_with_index { |e, i| 
	# 	record = Record.create({value: sub_array[e].to_f})
	# 	record.oiltype = oiltypes[i]
	# 	record.user = admin
	# 	record.revision = version
	# 	record.region = region
	# 	record.save!
	#  }
end

hash_standard = {0=> "国Ⅲ",
1=>"国Ⅳ",
2=>"国Ⅴ"}

hash_oiltype = {
	0=>"0号柴油",
1=>"5号柴油",
2=>"10号柴油",
3=>"-10号柴油",
4=>"-20号柴油",
5=>"-30号柴油",
6=>"-35号柴油",
7=>"89号汽油",
8=>"90号汽油",
9=>"92号汽油",
10=>"93号汽油",
11=>"95号汽油",
12=>"97号汽油",
13=>"98号汽油"
}

hash_standard.each do |variable|
	standard = Standard.create({name: variable.last,id:variable.first})
	hash_oiltype.each do |variable|
		code = variable.first
		name = variable.last
		next if (standard.id == 0 || standard.id ==1) &&(code == 7 || code == 9 || code == 11)
		next if (standard.id == 2) && (code == 8 || code == 10 || code == 12)		
		oiltype = Oiltype.create({name: name,code: code})
		oiltype.standard = standard
		oiltype.save!
	end
end

