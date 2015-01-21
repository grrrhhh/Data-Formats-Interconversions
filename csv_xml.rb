require 'csv'
require 'json'
require 'csvlint'


def tagGenerator(tag,data)
	return "<"+tag+">"+data+"</"+tag+">\n"
end

def csv_json(input_file,output_file,first_row_headers=true)
	if !File.file?(input_file)
		puts "Input File does not exist "
		return
	end
	if output_file.nil?||output_file.empty?
		output_file="/tmp/#{from.split(".")[0]}.xml"
	end

	out_file = File.open(output_file,"w")
	out_file.write('<?xml version="1.0"?>'+"\n")
	out_file.write("<ROWSET>\n")

	columns=[]
	CSV.foreach(input_file ,headers:false) do |row|
  	if !columns.empty?
  		h=Hash[columns.zip(row)]
  		out_file.write("<ROW>\n")
  		h.each do |k,v|
  			out_file.write(tagGenerator(k,v))
  		end
  		out_file.write("</ROW>\n")
  	else
   		columns = first_row_headers ? row : (1..row.size).map{|i| "COLM_"+i.to_s }
 		end
	end	
	out_file.write('</ROWSET>'+"\n")
	out_file.close()
end

csv_json("test/op.csv","test/xyz.xml")