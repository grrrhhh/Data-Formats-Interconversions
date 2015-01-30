require "json"


def json_csv_jq(ip_file,op_file,cta="")

	if !File.file?(ip_file)
		puts "Input File does not exist."
		return
	end
	if op_file.nil?||op_file.empty?
		op_file="/tmp/#{from.split(".")[0]}.json"
	end

	if cta.empty?
		value_lengths=value_cta=%x(./jq '[.[]|arrays|length]' #{ip_file})
		value_lengths=JSON.parse(value_lengths)

		value_index=value_lengths.rindex(value_lengths.max)
		
		actual_value=%x(./jq '[.[]|arrays][#{value_index}]' #{ip_file})
		actual_value=JSON.parse(actual_value)
		
		if value_class_type(actual_value)
			fill_output_file(actual_value,op_file)
		else
			puts "Data format not supported (it should be Array of hash)."
		end

	elsif cta=="-a"

		values_frm_file=%x(./jq '[.[]|arrays]' #{ip_file})
		json_of_value=JSON.parse(values_frm_file)
		
		json_of_value.each_with_index do |value,index|
			if value_class_type(value)
				fill_output_file(value,"test/op_"+index.to_s+".csv")
			end
		end

	else	
		
		value_at_cta=%x(./jq '.#{cta}' #{ip_file})
		json_of_cta_data=JSON.parse(value_cta)
		
		if !json_of_cta_data.empty?
			if value_class_type(json_of_cta_data)
				fill_output_file(json_of_cta_data,op_file)
			else
				puts "Data format not supported (it should be Array of hash)."
			end
		else
			puts "'#{cta}' no such key exist in the file."
		end

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

json_csv_jq("test/ip_j2c.json","test/op.csv","employees1")