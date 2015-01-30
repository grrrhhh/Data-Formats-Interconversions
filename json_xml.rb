require "json"

def tagGenerator(tag,data)
	return "<"+tag+">"+data+"</"+tag+">\n"
end

def json_xml(ip_file,op_file)
	if !File.file?(ip_file)
		puts "Input File does not exist "
		return
	end
	if op_file.nil?||op_file.empty?
		op_file="/tmp/#{from.split(".")[0]}.xml"
	end

	og_file=File.read(ip_file)
	json_data=JSON.parse(og_file)
	
	output_file = File.open(op_file,"w")

	output_file.write('<?xml version="1.0"?>'+"\n")
	output_file.write("<root>\n")	

	json_data.each do |key,value|
		if value_class_type(value)
			fill_elements(key,value,output_file)
		else
			output_file.write(tagGenerator(key,value))
		end
	end
	output_file.write("</root>\n")	
	output_file.close()

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



def fill_elements(keys,values,output_file)
	#puts values[0].class
	values.each do |elements|
		output_file.write("<#{keys}>\n")
		# output_file.write("<element>\n")
		elements.each do |k,v|
			output_file.write(tagGenerator(k,v))
		end
		output_file.write("</#{keys}>\n")
		# output_file.write("</element>\n")
	end
end

json_xml("test/ip_j2c.json","test/temp.xml")