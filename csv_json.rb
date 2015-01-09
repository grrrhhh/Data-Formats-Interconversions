require 'csv'
require 'json'
require 'csvlint'

def csv_json(input_file,output_file,first_row_headers=true)
	if !File.file?(input_file)
		puts "Input File does not exist "
		return
	end
	if output_file.nil?||output_file.empty?
		output_file="/tmp/#{from.split(".")[0]}.json"
	end

	out_file = File.open(output_file,"w")
	out_file.write("{\n")

	columns=[]
	begin
		CSV.foreach(input_file ,headers:false) do |row|
  		if !columns.empty?
    		h=Hash[columns.zip(row)].to_json
    		out_file.write(h + ",\n")
  		else
    		columns = first_row_headers ? row : (1..row.size).map{|i| "COLM_"+i.to_s }
 	 		end
		end	
	rescue Exception => e
		p e
		puts "---"
		validator = Csvlint::Validator.new( File.new(input_file))
		puts validator.errors
		puts validator.warnings
		puts validator.info_messages
	end

	out_file.seek(-2, IO::SEEK_END)
	out_file.write("\n}\n")	
end

csv_json("File2.csv","out2.json")