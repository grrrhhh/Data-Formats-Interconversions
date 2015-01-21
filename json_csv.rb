require "json"


def json_csv(ip_file,op_file,cta="")
	og_file=File.read(ip_file)
	json_data=JSON.parse(og_file)

#	a=[]

	hash_of_keylen=Hash.new
	
	if cta.empty?
		json_data.each do |k,v|
			if value_class_type(v)
				hash_of_keylen[k]=v.size
			end
		end
		max_key=get_max_valued_key(hash_of_keylen)
		fill_output_file(json_data[max_key],op_file)

	elsif cta=="-a"

		json_data.each do |k,v|
			if value_class_type(v)
				fill_output_file(v,"test/op_"+k+".csv")
			end
		end

	else
		
		fill_output_file(json_data[cta],op_file)
	
	end

end



def value_class_type (value_part)
	if value_part.class == Array
		if value_part[0].class == Hash
			return true
		end
	else
		return false
	end
end



def fill_output_file(val,op_file)
	output_file = File.open(op_file,"w")
	print val
	puts val.class
	header=[]


	val.each do |item|
		if !header.empty?
			data=[]
			item.each_value do |v|
				data.push(v)
			end
			output_file.write(data.join(",")+"\n")
		else
			data=[]
			item.each do |k,v|
				header.push(k)
				data.push(v)
			end
			output_file.write(header.join(",")+"\n")
			output_file.write(data.join(",")+"\n")
		end	
	end
end

def get_max_valued_key (hash_obj)
	max_value = hash_obj.values.max
	hkeys= hash_obj.select{|k, v| v == max_value}.keys
	hkeys[0]
end


json_csv("test/ip_j2c.json","test/op.csv","-a")